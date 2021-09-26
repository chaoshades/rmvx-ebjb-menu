#===============================================================================
# ** Game Party
#------------------------------------------------------------------------------
#  Function aliases for custom menu
#===============================================================================

class Game_Party
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array containing the newest gained items
  attr_reader   :newest_items
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize
    initialize_ebjb
    @newest_items = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias gain item
  #--------------------------------------------------------------------------
  alias gain_item_ebjb gain_item unless $@
  def gain_item(item, n, include_equip = false)
    # gain item
    if n > 0
      # don't update newest_items in Equip scene
      if !$scene.is_a?(Scene_Equip)      
        if @newest_items.length == MENU_CONFIG::MAX_NEWEST_ITEMS
          @newest_items.pop()
        end
        @newest_items.insert(0,item)
      end
    # lose item
    else
      if @newest_items.include?(item)
        @newest_items.delete(item)
      end
    end
    gain_item_ebjb(item, n, include_equip)
  end
  
end
