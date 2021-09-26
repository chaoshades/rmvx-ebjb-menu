#==============================================================================
# ** Window_Status_Equip
#------------------------------------------------------------------------------
#  This window displays the items the actor is currently equipped with
#==============================================================================

class Window_Status_Equip < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCEquipItem for every item the actor is equipped with
  attr_reader :ucEquipItemsList
  # Actor object
  attr_reader :actor
  
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
  #     x     : window X coordinate
  #     y     : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @ucEquipItemsList = []
    window_update(actor)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      @actor = actor
      equips = actor.equips
      @data = []
      if equips != nil
        for item in equips
          @data.push(item)
        end
        @item_max = @data.size
        create_contents()
        @ucEquipItemsList.clear()
        for i in 0..@item_max-1
          @ucEquipItemsList.push(create_item(i))
        end
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @ucEquipItemsList.each() { |equipItem| equipItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_item != nil
      @help_window.window_update(selected_item.description)
    else
      @help_window.window_update("")
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
  # * Update cursor
  #--------------------------------------------------------------------------
  alias update_cursor_ebjb update_cursor unless $@ 
  def update_cursor
    update_cursor_ebjb
    if !self.cursor_rect.nil?
      # Change default cursor position
      rect = item_rect(@index*2+1)
      rect.y -= self.oy
      self.cursor_rect = rect
    end
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the EquipItems list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)

    case index
    when 0
      if @actor.two_swords_style
        kindDesc = Vocab::weapon1
      else
        kindDesc = Vocab::weapon
      end
    when 1
      if @actor.two_swords_style
        kindDesc = Vocab::weapon2
      else
        kindDesc = Vocab::armor1
      end
    when 2
      kindDesc = Vocab::armor2
    when 3
      kindDesc = Vocab::armor3
    when 4
      kindDesc = Vocab::armor4
    end
    
    rect.y += WLH*index 
    equipItem = UCEquipItem.new(self, item, rect, kindDesc)
     
    f = Font.new()
    f.color = system_color
    equipItem.cEquipKind.font = f
    return equipItem
  end
  private :create_item
  
end
