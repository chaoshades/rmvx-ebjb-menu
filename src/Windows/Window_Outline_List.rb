#==============================================================================
# ** Window_Outline_List
#------------------------------------------------------------------------------
# Plot Summary List Display Window
#==============================================================================

class Window_Outline_List < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of Labels for every outline
  attr_reader :cOutlinesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get current outline info
  #--------------------------------------------------------------------------
  # GET
  def selected_outline
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     outlines : outlines list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, outlines)
    super(x, y, width, height)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT

    @column_max = 1
    @cOutlinesList = []
    window_update(outlines)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     outlines : outlines list
  #--------------------------------------------------------------------------
  def window_update(outlines)
    @data = []
    if outlines != nil
      outlines.each_with_index { |oline, i|
        if $game_system.outline_enable[i]
          @data << OutlineList_Info.new(oline[0], oline[1], i)
        elsif !KGC::Outline::OLINE_HIDE_DISABLED
          @data << OutlineList_Info.new(KGC::Outline::OLINE_DISABLED_TITLE, nil, i)
        end
      }
      @item_max = @data.size
      create_contents()
      @cOutlinesList.clear()
      for i in 0..@item_max-1
        @cOutlinesList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cOutlinesList.each() { |cOutline| cOutline.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for OutlinesList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index)
    # Lists
    $game_system.outline_enable = [] if $game_system.outline_enable == nil
    $game_system.outline_complete = [] if $game_system.outline_complete == nil
    
    # Generate Title
    text = ($game_system.outline_complete[item.index] ?
      KGC::Outline::OLINE_COMPLETION_SYMBOL : KGC::Outline::OLINE_INCOMPLETION_SYMBOL) +
      (KGC::Outline::OLINE_SERIAL_NUMBER ? sprintf("%0*d : ",
      KGC::Outline::OLINE_SERIAL_NUMBER_DIGITS, item.index + 1) : "") +
      item.title

    cOutline = CLabel.new(self, rect, text)
    cOutline.active = $game_system.outline_enable[item.index]
    
    return cOutline
  end
  private :create_item
  
end
