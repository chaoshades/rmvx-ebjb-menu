#==============================================================================
# ** UCPartyCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status in the custom 
#  party menu
#==============================================================================

class UCPartyCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icons list for the actives states of the character
  attr_reader :ucActStates
  # CImage for the character's image
  attr_reader :cCharImage
  # CLabel for the character's name
  attr_reader :cCharName
  # UCLabelValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the HP stat of the character
  attr_reader :ucHpStat
  # UCBar for the HP stat gauge of the character
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the MP stat of the character
  attr_reader :ucMpStat
  # UCBar for the MP stat gauge of the character
  attr_reader :cMpStatGauge
  # UCLabelIconValue for the character's experience
  attr_reader :ucExp
  # UCBar for the EXP gauge of the character
  attr_reader :cExpGauge
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
    @ucActStates.visible = visible
    @cCharImage.visible = visible
    @cCharName.visible = visible
    @ucCharLvl.visible = visible
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
    @ucExp.visible = visible
    @cExpGauge.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucActStates.active = active
    @cCharImage.active = active
    @cCharName.active = active
    @ucCharLvl.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
    @ucExp.active = active
    @cExpGauge.active = active
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
    
    @ucActStates = UCLabelIconsSwitchableList.new(window, rects[0], rects[0], 
                           "", [0], MENU_CONFIG::ACT_STATES_MAX_ICONS, 
                           MENU_CONFIG::ACT_STATES_ICONS_TIMEOUT)  
    @ucActStates.active = active
    @ucActStates.visible = visible
    
    iconsArray = []
    for i in 0 .. actor.states.size-1
      iconsArray[i] = actor.states[i].icon_index
    end
    @ucActStates.icons = iconsArray
    
    bodyImg = MENU_CONFIG::BODY_IMAGES[actor.id]
    @cCharImage = CImage.new(window, rects[1], Cache.picture(bodyImg.filename), 
                             bodyImg.src_rect)
    @cCharImage.valign = 2
    @cCharImage.active = active
    @cCharImage.visible = visible
    
    if actor.dead?
      @cCharImage.active = false 
    end
    
    @cCharName = CLabel.new(window, rects[2], 
                            actor.name, 1, Font.bold_font)
    @cCharName.active = active
    @cCharName.visible = visible
    
    @ucCharLvl = UCLabelValue.new(window, rects[3][0], rects[3][1], 
                                  Vocab::lvl_label, actor.level)
    @ucCharLvl.cLabel.font = Font.party_stat_font
    @ucCharLvl.cValue.font = Font.party_stat_font
    @ucCharLvl.cLabel.align = 2
    @ucCharLvl.cValue.align = 2
    @ucCharLvl.active = active
    @ucCharLvl.visible = visible
    
    @ucHpStat = UCLabelIconValue.new(window, rects[4][1], rects[4][0], rects[4][2],
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
    @cHpStatGauge = UCBar.new(window, rects[5], 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color, 
                              actor.hp, actor.maxhp, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[6][1], rects[6][0], rects[6][2],
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
    @cMpStatGauge = UCBar.new(window, rects[7], 
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color, 
                              actor.mp, actor.maxmp, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
    if (actor.next_exp == 0)
      gauge_min = 1
      gauge_max = 1
      exp_value = MENU_CONFIG::MAX_EXP_GAUGE_VALUE
    else
      gauge_min = actor.now_exp
      gauge_max = actor.next_exp
      exp_value = sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.now_exp, actor.next_exp)
    end
    
    @ucExp = UCLabelIconValue.new(window, rects[8][1], rects[8][0], rects[8][2],
                                     Vocab::exp_label, MENU_CONFIG::ICON_EXP, 
                                     exp_value)
    @ucExp.cValue.align = 2
    @ucExp.cValue.font = Font.party_stat_font
    @ucExp.active = active
    @ucExp.visible = visible
    
    @cExpGauge = UCBar.new(window, rects[9], 
                           Color.exp_gauge_color1, Color.exp_gauge_color2, Color.gauge_back_color,  
                           gauge_min, gauge_max, 1, Color.gauge_border_color)                    
    @cExpGauge.active = active
    @cExpGauge.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucActStates.draw()
    @cCharImage.draw()
    @cCharName.draw()
    @ucCharLvl.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
    @cExpGauge.draw()
    @ucExp.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,100,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[3] = [Rect.new(rect.x,rect.y,rect.width,18),
                Rect.new(rect.x,rect.y,18,18)]
    rects[4] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[5] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[6] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[7] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[8] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[9] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    gauge_value_width = rect.width - right_pad
    gauge_y = 16
    
    # Rects Adjustments
    
    # ucActStates
    rects[0].x += ((rect.width - rects[0].width) / 2).floor
    rects[0].y += spacing*3
    
    # cCharImage
    rects[1].height -= spacing*3
    
    # cCharName
    # Nothing to do
    
    # ucCharLvl
    rects[3][0].y += spacing
    rects[3][0].width -= rects[3][1].width
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    
    # ucHpStat   
    rects[4][0].y += rect.height - spacing*4
    rects[4][1].x += rects[4][0].width
    rects[4][1].y = rects[4][0].y
    rects[4][2].y = rects[4][0].y + spacing
    rects[4][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[5].y = rects[4][0].y+gauge_y
    rects[5].height = rects[4][0].height-gauge_y
    
    # ucMpStat
    rects[6][0].y += rect.height - spacing*2
    rects[6][1].x += rects[6][0].width
    rects[6][1].y = rects[6][0].y
    rects[6][2].y = rects[6][0].y + spacing
    rects[6][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[7].y = rects[6][0].y+gauge_y
    rects[7].height = rects[6][0].height-gauge_y
    
    # ucExpStat
    rects[8][0].y += spacing
    rects[8][1].x += rects[8][0].width
    rects[8][1].y = rects[8][0].y
    rects[8][2].y = rects[8][0].y + spacing
    rects[8][2].width = gauge_value_width
    
    # cExpGauge
    rects[9].y = rects[8][0].y+gauge_y
    rects[9].height = rects[8][0].height-gauge_y
    
    return rects
  end
  private :determine_rects
  
end
