#==============================================================================
# ** UCSaveCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status in the custom save menu
#==============================================================================

class UCSaveCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCharacterFace for the character's face
  attr_reader :ucCharFace
  # Label for the character's name
  attr_reader :cCharName
  # UCLabelValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's HP
  attr_reader :ucHpStat
  # UCBar for the HP gauge of the character
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the character's MP
  attr_reader :ucMpStat
  # UCBar for the MP gauge of the character
  attr_reader :cMpStatGauge
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
    @ucCharFace.visible = visible
    @cCharName.visible = visible
    @ucCharLvl.visible = visible
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucCharFace.active = active
    @cCharName.active = active
    @ucCharLvl.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     actor : actor object
  #     rect : rectangle to position the controls for the enemy
  #     spacing : spacing between controls
  #     right_pad : right padding to add to the values
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, actor, rect, spacing=18, right_pad=2,
                 active=true, visible=true)
    super(active, visible)
    @actor = actor
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing, right_pad)
    
    @ucCharFace = UCCharacterFace.new(window, rects[0], actor)
    @ucCharFace.active = active
    @ucCharFace.visible = visible
    
    if actor.dead?
      @ucCharFace.active = false    
    end
    
    @cCharName = CLabel.new(window, rects[1], actor.name, 1, Font.bold_font)
    @cCharName.active = active
    @cCharName.visible = visible

    @ucCharLvl = UCLabelValue.new(window, rects[2][0], rects[2][1],
                                  Vocab::lvl_label, actor.level)
    @ucCharLvl.cLabel.font = Font.party_stat_font
    @ucCharLvl.cValue.font = Font.party_stat_font
    @ucCharLvl.cLabel.align = 1
    @ucCharLvl.cValue.align = 1
    @ucCharLvl.active = active
    @ucCharLvl.visible = visible
    
    @ucHpStat = UCLabelIconValue.new(window, rects[3][1], rects[3][0], rects[3][2],
                                     Vocab::hp_label, MENU_CONFIG::ICON_HP, 
                                     sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.hp, actor.maxhp))
    @ucHpStat.cValue.align = 2
    @ucHpStat.cValue.font = Font.party_stat_font
    
    if actor.hp == 0
      @ucHpStat.cValue.font.color = Color.knockout_color
    elsif actor.hp < actor.maxhp / 4
      @ucHpStat.cValue.font.color = Color.crisis_color
    else
      @ucHpStat.cValue.font.color = Color.normal_color
    end
    
    @ucHpStat.active = active
    @ucHpStat.visible = visible
    @cHpStatGauge = UCBar.new(window, rects[4], 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color, 
                              actor.hp, actor.maxhp, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[5][1], rects[5][0], rects[5][2], 
                                     Vocab::mp_label, MENU_CONFIG::ICON_MP, 
                                     sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.mp, actor.maxmp))
    @ucMpStat.cValue.align = 2
    @ucMpStat.cValue.font = Font.party_stat_font
    
    if actor.mp < actor.maxmp / 4
      @ucMpStat.cValue.font.color = Color.crisis_color
    else
      @ucMpStat.cValue.font.color = Color.normal_color
    end
    
    @ucMpStat.active = active
    @ucMpStat.visible = visible
    @cMpStatGauge = UCBar.new(window, rects[6], 
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color, 
                              actor.mp, actor.maxmp, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucCharFace.draw()
    @cCharName.draw()
    @ucCharLvl.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #     right_pad : right padding to add to the values
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing, right_pad)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,96,96)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[2] = [Rect.new(rect.x,rect.y,rect.width,18),
                Rect.new(rect.x,rect.y,18,18)]
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[5] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[6] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    gauge_value_width = rect.width - right_pad
    gauge_y = 16
    
    # Rects Adjustments
    
    # ucCharFace
    rects[0].x += ((rect.width - rects[0].width) / 2).floor
    rects[0].y += spacing*2
    
    # cCharName
    # Nothing to do
    
    # ucCharLvl
    rects[2][0].y += spacing
    rects[2][0].width -= rects[2][1].width
    rects[2][1].x += (rects[2][0].width / 2).floor + rects[2][1].width
    rects[2][1].y = rects[2][0].y
    
    # ucHpStat   
    rects[3][0].y += rect.height - spacing*4
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].y = rects[3][0].y + spacing
    rects[3][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[4].y = rects[3][0].y+gauge_y
    rects[4].height = rects[3][0].height-gauge_y

    # ucMpStat
    rects[5][0].y += rect.height - spacing*2
    rects[5][1].x += rects[5][0].width
    rects[5][1].y = rects[5][0].y
    rects[5][2].y = rects[5][0].y + spacing
    rects[5][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[6].y = rects[5][0].y+gauge_y
    rects[6].height = rects[5][0].height-gauge_y
    
    return rects
  end
  private :determine_rects
  
end
