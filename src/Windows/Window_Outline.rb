#==============================================================================
# ** Window_Outline
#------------------------------------------------------------------------------
# Plot (content) to display window.
#==============================================================================

class Window_Outline < Window_Scrollable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Controls list to show the outline
  attr_reader :cControlsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     oline : outline non-parsed text
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, oline=nil)
    super(x, y, width, height, KGC::Outline::OLINE_SCROLL_SPEED)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
    
    @cControlsList = []
    window_update(oline)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     oline : outline non-parsed text
  #--------------------------------------------------------------------------
  def window_update(oline)
    if oline != nil
      #text = ""
      @last_color = 0
      @contents_x = 0
      @contents_y = 0
      @biggest_text_height = 0
      @cControlsList.clear()
      for l in oline
        next if l == nil
        converted_line = convert_special_characters(l)
        generate_controls(converted_line)
        new_line
      end

      # Changes contents size for scrolling
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, [self.height - 32, @contents_y].max)
      self.oy = 0
    end
    
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cControlsList.each() { |control| control.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Convert special characters from the outline text
  #     text : outline text
  #--------------------------------------------------------------------------
  def convert_special_characters(text)
    converted_text = text.clone
    #--------------------------
    # DEFAULT FEATURES
    #-----------------------
    converted_text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    converted_text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    converted_text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    
    #--------------------------
    # * NMS FEATURES!!
    #-----------------------
    # Woratana's :: Draw Weapon Name + Icon
    converted_text.gsub!(/\\DW\[([0-9]+)\]/i) { "\x83[#{$data_weapons[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::WEAPON_NAME_COLOR_ID}]\\nw[#{$1.to_i}]\x01[#{@last_color}]"}
    # Woratana's :: Draw Item Name + Icon
    converted_text.gsub!(/\\DI\[([0-9]+)\]/i) { "\x83[#{$data_items[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::ITEM_NAME_COLOR_ID}]\\ni[#{$1.to_i}]\x01[#{@last_color}]" }
    # Woratana's :: Draw Armor Name + Icon
    converted_text.gsub!(/\\DA\[([0-9]+)\]/i) { "\x83[#{$data_armors[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::ARMOR_NAME_COLOR_ID}]\\na[#{$1.to_i}]\x01[#{@last_color}]"}
    # Woratana's :: Draw Skill Name + Icon
    converted_text.gsub!(/\\DS\[([0-9]+)\]/i) { "\x83[#{$data_skills[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::SKILL_NAME_COLOR_ID}]\\ns[#{$1.to_i}]\x01[#{@last_color}]"}

    # Woratana's :: Draw Icon
    converted_text.gsub!(/\\IC\[([0-9]+)\]/i) { "\x83[#{$1}]" }

    # Woratana's :: Actor Class Name
    converted_text.gsub!(/\\NC\[([0-9]+)\]/i) { $data_classes[$game_actors[$1.to_i].class_id].name }
    # Woratana's :: Party Actor Name
    converted_text.gsub!(/\\NP\[([0-9]+)\]/i) { $game_party.members[($1.to_i - 1)].name }
    # Woratana's :: Monster Name
    converted_text.gsub!(/\\NM\[([0-9]+)\]/i) { $data_enemies[$1.to_i].name }
    # Woratana's :: Troop Name
    converted_text.gsub!(/\\NT\[([0-9]+)\]/i) { $data_troops[$1.to_i].name }
    # Woratana's :: Item Name
    converted_text.gsub!(/\\NI\[([0-9]+)\]/i) { $data_items[$1.to_i].name }
    # Woratana's :: Weapon Name
    converted_text.gsub!(/\\NW\[([0-9]+)\]/i) { $data_weapons[$1.to_i].name }
    # Woratana's :: Armor Name
    converted_text.gsub!(/\\NA\[([0-9]+)\]/i) { $data_armors[$1.to_i].name }
    # Woratana's :: Skill Name
    converted_text.gsub!(/\\NS\[([0-9]+)\]/i) { $data_skills[$1.to_i].name }
    # Woratana's :: Item Price
    converted_text.gsub!(/\\PRICE\[([0-9]+)\]/i) { $data_items[$1.to_i].price.to_s }
    
    # Woratana's :: Font Name Change
    converted_text.gsub!(/\\FN\[(.*?)\]/i) { "\x84[#{$1}]" }
    # Woratana's :: Font Size Change
    converted_text.gsub!(/\\FS\[([0-9]+)\]/i) { "\x85[#{$1}]" }
    # Woratana's :: Reset Font Name
    converted_text.gsub!(/\\REF/i) { "\x86" }
    # Woratana's :: Reset Font Size
    converted_text.gsub!(/\\RES/i) { "\x87" }
    # Woratana's :: BOLD Text
    converted_text.gsub!(/\\B/i) { "\x88" }
    # Woratana's :: ITALIC Text
    converted_text.gsub!(/\\I/i) { "\x89" }
     
    # NMS 2++
    # Woratana's :: SHADOW Text
    converted_text.gsub!(/\\SH/i) { "\x93" }

    # Woratana's :: Draw Picture
    converted_text.gsub!(/\\DP\[(.*?),SIZE\{([0-9]+),([0-9]+)\},BORDER\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{$2},#{$3},#{$4},#{$5}]" }
    converted_text.gsub!(/\\DP\[(.*?),SIZE\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{$2},#{$3},#{nil},#{nil}]" }
    converted_text.gsub!(/\\DP\[(.*?),BORDER\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{nil},#{nil},#{$2},#{$3}]" }
    converted_text.gsub!(/\\DP\[(.*?)\]/i) { "\x11[#{$1}]" }
    
    # Woratana's :: Draw Face
    converted_text.gsub!(/\\FA\[([0-9]+)\]/i) { "\x12[#{$1}]" }
    
    return converted_text
  end
  private :convert_special_characters
  
  #--------------------------------------------------------------------------
  # * Generate dynamically the controls from the outline text
  #     text : outline text
  #--------------------------------------------------------------------------
  def generate_controls(text)
    contents_text = ""
    loop do
      c = text.slice!(/./m)
      case c
      when nil
        break
    #--------------------------
    # DEFAULT FEATURES
    #-----------------------
      when "\x01"
        text.sub!(/\[([0-9]+)\]/, "")
        @last_color = $1.to_i
        contents.font.color = text_color($1.to_i)
        
    #--------------------------
    # * NMS FEATURES!!
    #-----------------------
      when "\x83"
        text.sub!(/\[([0-9]+)\]/, "")

        new_line if (@contents_x + 24 > contents.width)

        # Draw ICON
        ucIcon = UCIcon.new(self, Rect.new(@contents_x, @contents_y, 24, 24), $1.to_i)
        @cControlsList.push(ucIcon)
        @contents_x += 24
      when "\x84"
        text.sub!(/\[(.*?)\]/, "")
        contents.font.name = $1.to_s
      when "\x85"
        text.sub!(/\[([0-9]+)\]/, "")
        contents.font.size = $1.to_i
      when "\x86"
        contents.font.name = Font.default_name 
      when "\x87"
        contents.font.size = Font.default_size
      when "\x88"
        contents.font.bold = contents.font.bold == true ? false : true
      when "\x89"
        contents.font.italic = contents.font.italic == true ? false : true
      when "\x93"
        contents.font.shadow = contents.font.shadow == true ? false : true
      when "\x11"
        text.sub!(/\[(.*?)\]/, "")
        a = $1.to_s.split(',')
        bitmap = Cache.picture(a[0])

        new_line if (@contents_x + bitmap.width > contents.width)
        
        # Size
        if !a[1].nil? && !a[1].empty?
          width = a[1].to_i
        else
          width = bitmap.width
        end
        if !a[2].nil? && !a[2].empty?
          height = a[2].to_i
        else
          height = bitmap.height
        end
      
        # Border
        if !a[3].nil? && !a[3].empty?
          border = a[3].to_i 
        else
          border = 0
        end
        if !a[4].nil? && !a[4].empty?
          border_color = text_color(a[4].to_i)
        else
          border_color = nil
        end

        # Draw Image
        ucImageBorder = UCImageBorder.new(self, Rect.new(@contents_x, @contents_y, width, height),
                                          bitmap, Rect.new(0,0, width-border*2, height-border*2),
                                          0, 255, 0, border, border_color)
        @cControlsList.push(ucImageBorder)
        
        @contents_x += width
        @biggest_text_height = height if height > @biggest_text_height
        #bitmap.dispose
      when "\x12"
        text.sub!(/\[([0-9]+)\]/, "")

        new_line if (@contents_x + 96 > contents.width)

        # Draw Face
        actor = Game_Actor.new($1.to_i)
        ucCharFace = UCCharacterFace.new(self, Rect.new(@contents_x, @contents_y, 96, 96), actor)
        @cControlsList.push(ucCharFace)
        
        @biggest_text_height = 96 if 96 > @biggest_text_height
      else
        # Draw Text
        next_char = text.slice(/./m)
        contents_text += c
        if next_char == nil || next_char.match(/[\x01-\x12\x80-\xff]/) != nil
          text_height = contents.get_text_height(contents_text)
          if text_height < WLH
            text_height = WLH
          end
          @biggest_text_height = text_height if text_height > @biggest_text_height

          rect = Rect.new(@contents_x, @contents_y, contents.width, @biggest_text_height)
          cLabel = CLabel.new(self, rect, contents_text, 0, contents.font.clone, 
                              true, false, 3)
          @cControlsList.push(cLabel)
          
          lines = contents.split_multiline(rect, contents_text, 3)
          if lines.size > 1
            text_height = contents.get_text_height(contents_text)
            if text_height < WLH
              text_height = WLH
            end
            text_height = @biggest_text_height + text_height * (lines.size-2)
            @biggest_text_height = text_height if text_height > @biggest_text_height
            new_line
          end

          contents_text = ""
          @contents_x += contents.get_text_width(lines[lines.size-1])
        end
        
      end
    end

  end
  private :generate_controls
  
  #--------------------------------------------------------------------------
  # * Creates a new line
  #--------------------------------------------------------------------------
  def new_line
    biggest = @biggest_text_height > WLH ? @biggest_text_height : WLH
    @contents_x = 0 
    @contents_y += biggest
    @biggest_text_height = WLH
  end
  private :new_line
  
end
