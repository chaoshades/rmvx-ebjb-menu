#==============================================================================
# ** Window_Skill_Status
#------------------------------------------------------------------------------
#  This window displays the skill user's status on the skill screen.
#==============================================================================

class Window_Skill_Status < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the character name
  attr_reader :cCharName
  # UCLabelIconValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's HP
  attr_reader :ucHpStat
  # UCBar for the HP gauge of the character
  attr_reader :ucHpStatGauge
  # UCLabelIconValue for the character's MP
  attr_reader :ucMpStat
  # UCBar for the MP gauge of the character
  attr_reader :ucMpStatGauge
    
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)

    @cCharName = CLabel.new(self, Rect.new(0,0,200,WLH), "")
    @cCharName.font = Font.bold_font
    
    @ucCharLvl = UCLabelIconValue.new(self, Rect.new(24,24,50,WLH), 
                                     Rect.new(0,24,24,24), 
                                     Rect.new(50,24,110, WLH), 
                                     Vocab::lvl_label, 
                                     MENU_CONFIG::ICON_LVL, "")
    @ucCharLvl.cValue.align = 2
    
    @ucHpStat = UCLabelIconValue.new(self, Rect.new(24,48,25,WLH), 
                                     Rect.new(0,48,24,24), 
                                     Rect.new(25,48,135, WLH), 
                                     Vocab::hp_label, 
                                     MENU_CONFIG::ICON_HP, "")
    @ucHpStat.cValue.align = 2
    
    @ucHpStatGauge = UCBar.new(self, Rect.new(0, 48+16, 162, WLH-16), 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)

    @ucMpStat = UCLabelIconValue.new(self, Rect.new(24,72,25,WLH), 
                                     Rect.new(0,72,24,24), 
                                     Rect.new(25,72,135, WLH),  
                                     Vocab::mp_label, 
                                     MENU_CONFIG::ICON_MP, "")
    @ucMpStat.cValue.align = 2
    
    @cMpStatGauge = UCBar.new(self, Rect.new(0, 72+16, 162, WLH-16),  
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)                    
    
    window_update(actor)
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
      @cCharName.text = actor.name
      @ucCharLvl.cValue.text = actor.level
      
      @ucHpStat.cValue.text = sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.hp, actor.maxhp)
      @ucHpStatGauge.value = actor.hp
      @ucHpStatGauge.max_value = actor.maxhp
      
      if actor.hp == 0
        @ucHpStat.cValue.font.color = Color.knockout_color
      elsif actor.hp < actor.maxhp / 4
        @ucHpStat.cValue.font.color = Color.crisis_color
      else
        @ucHpStat.cValue.font.color = Color.normal_color
      end
      
      @ucMpStat.cValue.text = sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.mp, actor.maxmp)
      @cMpStatGauge.value = actor.mp
      @cMpStatGauge.max_value = actor.maxmp
      
      if actor.mp < actor.maxmp / 4
        @ucMpStat.cValue.font.color = Color.crisis_color
      else
        @ucMpStat.cValue.font.color = Color.normal_color
      end
      
    end
    refresh()
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cCharName.draw()
    @ucCharLvl.draw()
    @ucHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
  end
  
end
