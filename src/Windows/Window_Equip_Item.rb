#==============================================================================
# ** Window_Equip_Item
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
# equipment screen.
#==============================================================================

class Window_Equip_Item < Window_Item
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Equip type used for the choices of equipment in the window
  attr_accessor :equip_type
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the current equip type
  #--------------------------------------------------------------------------
  # SET
  def equip_type=(equip_type)
    if equip_type == 1 and @actor.two_swords_style
      equip_type = 0                              # Change shield to weapon
    end
    @equip_type = equip_type
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
  #     actor : actor object
  #     equip_type : equip region (0-4)
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, equip_type)
    @actor = actor
    @equip_type = equip_type
    super(x, y, width, height, nil)
    @column_max = 1
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether to include item in list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return true if item == nil
    if @equip_type == 0
      return false unless item.is_a?(RPG::Weapon)
    else
      return false unless item.is_a?(RPG::Armor)
      return false unless item.kind == @equip_type - 1
    end
    return @actor.equippable?(item)
  end
  
  #--------------------------------------------------------------------------
  # * Whether to display item in enabled state
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end
  
end
