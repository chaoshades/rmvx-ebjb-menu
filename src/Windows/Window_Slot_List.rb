#==============================================================================
# ** Window_Slot_List
#------------------------------------------------------------------------------
#  This window displays save slots list
#==============================================================================

class Window_Slot_List < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCLabelIcon for every save slot
  attr_reader :ucSavesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current save
  #--------------------------------------------------------------------------
  # GET
  def selected_save
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     saves : saves list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, saves)
    super(x, y, width, height)
    @column_max = 1
    @ucSavesList = []
    window_update(saves)
    self.index = 0
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     saves : saves list
  #--------------------------------------------------------------------------
  def window_update(saves)
    @data = []
    if saves != nil
      for save in saves
        if save != nil
          @data.push(save)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucSavesList.clear()
      for i in 0..@item_max-1
        @ucSavesList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucSavesList.each() { |ucSave| ucSave.draw() }
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SavesList
  #     index : save index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index)
    
    if item.used
      icon_index = Wora_NSS::SAVED_SLOT_ICON
    else
      icon_index = Wora_NSS::EMPTY_SLOT_ICON
    end
    
    ucSave = UCLabelIcon.new(self, Rect.new(rect.x+24,rect.y,rect.width-24-32-2,24), 
                             Rect.new(rect.x,rect.y,24,24),
                             item.slot_name, icon_index, item.used)
                              
    return ucSave
  end
  private :create_item
  
end
