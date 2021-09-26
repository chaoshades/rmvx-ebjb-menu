#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays a list of inventory items for the item screen, etc.
#==============================================================================

class Window_Item < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
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
  #     items : items list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, items, dataview=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(items, dataview)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     items : items list
  #--------------------------------------------------------------------------
  def window_update(items, dataview=nil)
    @data = []
    if dataview != nil
      items = apply_dataview(dataview, items)
    end
    
    if items != nil
      for item in items
        if item != nil && include?(item)
          @data.push(item)
          if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
            self.index = @data.size - 1
          end
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(item == nil ? "" : item.description)
    else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && 
           ((selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_ItemDetails)) ||
           (!selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #--------------------------------------------------------------------------
  # * Draw a specific item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = create_item(index)
    item.draw()
  end
  
  #--------------------------------------------------------------------------
  # * Return true if there are items in the list else false
  #--------------------------------------------------------------------------
  def hasItems
    return @ucItemsList.size > 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
    
    if $game_party.newest_items.include?(item)
      ucItem.cItemName.font.color = Color.new_item_color
      ucItem.cItemNumber.font.color = Color.new_item_color
    end
                              
    return ucItem
  end
  private :create_item
  
  #--------------------------------------------------------------------------
  # * Apply dataview to a list
  #     list : data to apply the dataview
  #--------------------------------------------------------------------------
  def apply_dataview(dataview, list)
    new_list = []
    
    if dataview.is_a?(Comparer)
      new_list = list.sort{|x,y| dataview.compare(x,y)}
    elsif dataview.is_a?(Filter)
      new_list = list.find_all{|x| dataview.apply(x)}
    end
    
    return new_list
  end
  private :apply_dataview
  
end
