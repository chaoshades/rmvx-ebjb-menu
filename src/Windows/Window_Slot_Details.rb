#==============================================================================
# ** Window_Slot_Details
#------------------------------------------------------------------------------
#  This window displays save slot details
#==============================================================================

class Window_Slot_Details < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label when the save slot is empty
  attr_reader :cEmptyLabel
  # UCImageBorder for the screenshot when the game was saved
  attr_reader :ucScreenshot
  # UCLabelValue for the location (or map) name
  attr_reader :ucLocation
  # UCLabelIcon for the current time
  attr_reader :ucTime
  # UCLabelIcon for the party's gold
  attr_reader :ucGold
  # Array for UCSaveCharStatus for the status of each member of the party
  attr_reader :ucCharFacesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     slot_id : save slot id
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, slot_id)
    super(x, y, width, height)
    
    @cEmptyLabel = CLabel.new(self, Rect.new(0,0, contents.width, contents.height - WLH), Wora_NSS::EMPTY_SLOT_TEXT, 1)

    @ucTime = UCLabelIcon.new(self, Rect.new(368,0,80,WLH), Rect.new(342,0,24,24), "", 188)
    @ucTime.cLabel.align = 2
    @ucTime.visible = Wora_NSS::DRAW_PLAYTIME
    
    @ucGold = UCLabelIcon.new(self, Rect.new(230,0,80,WLH), Rect.new(206,0,24,24), "", 147)
    @ucGold.cLabel.align = 2
    @ucGold.visible = Wora_NSS::DRAW_GOLD
    
    @ucScreenshot = UCImageBorder.new(self, Rect.new(0, 30, contents.width, 176), nil, nil, 
                                     0, 255, 0, 2, Color.image_border_color)
    @ucScreenshot.visible = Wora_NSS::SCREENSHOT_IMAGE
    
    @ucLocation = UCLabelValue.new(self, Rect.new(0,0,80,WLH), 
                                   Rect.new(0,@ucScreenshot.cImage.rect.height-18,
                                            @ucScreenshot.cImage.rect.width-2,(WLH*2)),
                                   Vocab::save_location_label, "")
    @ucLocation.visible = Wora_NSS::DRAW_LOCATION
    @ucLocation.cLabel.font = Font.bold_font
    @ucLocation.cValue.align = 2
    @ucLocation.cValue.font = Font.save_location_font
    @ucLocation.cValue.cut_overflow = true
    
    @ucCharFacesList = []
    
    window_update(slot_id)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     save_data : save data
  #--------------------------------------------------------------------------
  def window_update(save_data)
    if save_data != nil
      @save_data = save_data
      if save_data.used
        # DRAW SCREENSHOT
        if Wora_NSS::SCREENSHOT_IMAGE  
          if !@ucScreenshot.cImage.img_bitmap.nil?
            @ucScreenshot.cImage.img_bitmap.dispose
          end
          @ucScreenshot.cImage.img_bitmap = Bitmap.read_png(save_data.screenshot_stream)
          @ucScreenshot.cImage.src_rect = Rect.new((@ucScreenshot.cImage.img_bitmap.width-@ucScreenshot.cImage.rect.width)/2,
                                            (@ucScreenshot.cImage.img_bitmap.height-@ucScreenshot.cImage.rect.height)/2,
                                             @ucScreenshot.cImage.rect.width, @ucScreenshot.cImage.rect.height)
        end
       #else 
       # if SWAP_TILE and $game_switches[SWAP_TILE_SWITCH]
       #   create_swaptilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
       #   save_data['gamemap'].display_y)
       # else
       #   create_tilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
       #   save_data['gamemap'].display_y)
       # end
       #end
       
        # DRAW GOLD
        if Wora_NSS::DRAW_GOLD
          @ucGold.cLabel.text = save_data.game_par.gold
        end
        
        # DRAW PLAYTIME
        if Wora_NSS::DRAW_PLAYTIME
          @total_sec = save_data.frame_count / Graphics.frame_rate
          hour = @total_sec / 60 / 60
          min = @total_sec / 60 % 60
          sec = @total_sec % 60
          @ucTime.cLabel.text = sprintf(MENU_CONFIG::TIME_PATTERN, hour, min, sec)
        end
        
        # DRAW LOCATION
        if Wora_NSS::DRAW_LOCATION
          @ucLocation.cValue.text = save_data.game_map.name
        end
        
        # DRAW FACE & Level & Name
        @ucCharFacesList.clear()
        save_data.game_par.members.each_index do |i|
          actor = save_data.game_act[save_data.game_par.members[i].id]
          x_base = (i*100) + (i*16)
          @ucCharFacesList.push(UCSaveCharStatus.new(self, actor, Rect.new(x_base, 208, 100, 182)))
        end
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    if @save_data != nil
      if @save_data.used
        @ucTime.draw()
        @ucGold.draw()
        #contents.fill_rect(@cScreenshot.rect.x-2, @cScreenshot.rect.y-2, 
        #                   @cScreenshot.rect.width+4, @cScreenshot.rect.height+4,
        #                   Wora_NSS::MAP_BORDER)
        @ucScreenshot.draw()
        @ucLocation.draw()
        @ucCharFacesList.each() { |ucCharFace| ucCharFace.draw() }
      else
        @cEmptyLabel.draw()
      end
    else
      @cEmptyLabel.draw()
    end
  end
  
end
