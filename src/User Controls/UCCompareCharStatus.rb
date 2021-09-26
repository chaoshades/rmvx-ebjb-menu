#==============================================================================
# ** UCCompareCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status (used to compare
#  status with different equipment)
#==============================================================================

class UCCompareCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCompareStat for the HP status of the character
  attr_reader :ucHpCompareStat
  # UCCompareStat for the MP status of the character
  attr_reader :ucMpCompareStat
  # UCCompareStat for the ATK status of the character
  attr_reader :ucAtkCompareStat
  # UCCompareStat for the DEF status of the character
  attr_reader :ucDefCompareStat
  # UCCompareStat for the SPI status of the character
  attr_reader :ucSpiCompareStat
  # UCCompareStat for the AGI status of the character
  attr_reader :ucAgiCompareStat
  # UCCompareStat for the EVA status of the character
  attr_reader :ucEvaCompareStat
  # UCCompareStat for the HIT status of the character
  attr_reader :ucHitCompareStat
  # UCCompareStat for the CRI status of the character
  attr_reader :ucCriCompareStat
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucHpCompareStat.visible = visible
    @ucMpCompareStat.visible = visible
    @ucAtkCompareStat.visible = visible
    @ucDefCompareStat.visible = visible
    @ucSpiCompareStat.visible = visible
    @ucAgiCompareStat.visible = visible
    @ucEvaCompareStat.visible = visible
    @ucHitCompareStat.visible = visible
    @ucCriCompareStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucHpCompareStat.active = active
    @ucMpCompareStat.active = active
    @ucAtkCompareStat.active = active
    @ucDefCompareStat.active = active
    @ucSpiCompareStat.active = active
    @ucAgiCompareStat.active = active
    @ucEvaCompareStat.active = active
    @ucHitCompareStat.active = active
    @ucCriCompareStat.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     actor : actor object
  #     rect : rectangle to position the controls for the actor
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, actor, rect, spacing=24,
                 active=true, visible=true)
    super(active, visible)
    @actor = actor
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucHpCompareStat = UCCompareStat.new(window, rects[0], 
                                         Vocab::hp_label, MENU_CONFIG::ICON_HP)
    @ucHpCompareStat.active = active
    @ucHpCompareStat.visible = visible
    
    @ucMpCompareStat = UCCompareStat.new(window, rects[1], 
                                         Vocab::mp_label, MENU_CONFIG::ICON_MP)
    @ucMpCompareStat.active = active
    @ucMpCompareStat.visible = visible
    
    @ucAtkCompareStat = UCCompareStat.new(window, rects[2], 
                                          Vocab::atk_label, MENU_CONFIG::ICON_ATK)
    @ucAtkCompareStat.active = active
    @ucAtkCompareStat.visible = visible
    
    @ucDefCompareStat = UCCompareStat.new(window, rects[3], 
                                          Vocab::def_label, MENU_CONFIG::ICON_DEF)
    @ucDefCompareStat.active = active
    @ucDefCompareStat.visible = visible
    
    @ucSpiCompareStat = UCCompareStat.new(window, rects[4], 
                                          Vocab::spi_label, MENU_CONFIG::ICON_SPI)
    @ucSpiCompareStat.active = active
    @ucSpiCompareStat.visible = visible
    
    @ucAgiCompareStat = UCCompareStat.new(window, rects[5], 
                                          Vocab::agi_label, MENU_CONFIG::ICON_AGI)
    @ucAgiCompareStat.active = active
    @ucAgiCompareStat.visible = visible
    
    @ucEvaCompareStat = UCCompareStat.new(window, rects[6], 
                                          Vocab::eva_label, MENU_CONFIG::ICON_EVA, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucEvaCompareStat.active = active
    @ucEvaCompareStat.visible = visible
    
    @ucHitCompareStat = UCCompareStat.new(window, rects[7], 
                                          Vocab::hit_label, MENU_CONFIG::ICON_HIT, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucHitCompareStat.active = active
    @ucHitCompareStat.visible = visible
    
    @ucCriCompareStat = UCCompareStat.new(window, rects[8], 
                                          Vocab::cri_label, MENU_CONFIG::ICON_CRI, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucCriCompareStat.active = active
    @ucCriCompareStat.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update status with new actor
  #     compareActor : actor object to compare
  #--------------------------------------------------------------------------
  def update_status(compareActor)
    @ucHpCompareStat.set_values(@actor.maxhp, compareActor.maxhp - @actor.maxhp)
    @ucMpCompareStat.set_values(@actor.maxmp, compareActor.maxmp - @actor.maxmp)
    @ucAtkCompareStat.set_values(@actor.atk, compareActor.atk - @actor.atk)
    @ucDefCompareStat.set_values(@actor.def, compareActor.def - @actor.def)
    @ucSpiCompareStat.set_values(@actor.spi, compareActor.spi - @actor.spi)
    @ucAgiCompareStat.set_values(@actor.agi, compareActor.agi -  @actor.agi)
    @ucEvaCompareStat.set_values(@actor.eva, compareActor.eva - @actor.eva)
    @ucHitCompareStat.set_values(@actor.hit, compareActor.hit - @actor.hit)
    @ucCriCompareStat.set_values(@actor.cri, compareActor.cri - @actor.cri)
  end
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucHpCompareStat.draw()
    @ucMpCompareStat.draw()
    @ucAtkCompareStat.draw()
    @ucDefCompareStat.draw()
    @ucSpiCompareStat.draw()
    @ucAgiCompareStat.draw()
    @ucEvaCompareStat.draw()
    @ucHitCompareStat.draw()
    @ucCriCompareStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[3] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[4] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[5] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[6] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[7] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[8] = Rect.new(rect.x,rect.y,rect.width,24)
    
    # Rects Adjustments
    
    # ucHpCompareStat
    # Nothing to do
    
    # ucMpCompareStat
    rects[1].y += spacing
    
    # ucAtkCompareStat
    rects[2].y += spacing*2
    
    # ucDefCompareStat
    rects[3].y += spacing*3
        
    # ucSpiCompareStat
    rects[4].y += spacing*4
    
    # ucAgiCompareStat
    rects[5].y += spacing*5
    
    # ucEvaCompareStat
    rects[6].y += spacing*6
    
    # ucHitCompareStat
    rects[7].y += spacing*7
    
    # ucCriCompareStat
    rects[8].y += spacing*8
    
    return rects
  end
  private :determine_rects
  
end
