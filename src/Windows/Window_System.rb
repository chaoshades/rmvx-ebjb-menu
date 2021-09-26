#===============================================================================
# ** Window_System
#------------------------------------------------------------------------------
#  This window displays system options
#===============================================================================

class Window_System < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for Window Skin
  attr_reader :cWindowSkinsLabel
  # Array of Labels for every options for Window Skin
  attr_reader :cWindowSkinsOptions
  # UCVolumeControl for the BGM Volume
  attr_reader :ucBGMVolume
  # UCVolumeControl for the SFX Volume
  attr_reader :ucSFXVolume
  # UCVolumeControl for the BGS Volume
  attr_reader :ucBGSVolume
  # Label for Battle Animation
  attr_reader :cBattleAnimLabel
  # Array of Labels for every options for Battle Animation
  attr_reader :cBattleAnimOptions
  # Label for Auto-Dash
  attr_reader :cAutoDashLabel
  # Array of Labels for every options for Auto-Dash
  attr_reader :cAutoDashOptions
  # Label for Instant Text
  attr_reader :cInstantTextLabel
  # Array of Labels for every options for Instant Text
  attr_reader :cInstantTextOptions
  # Label for Difficulty
  attr_reader :cDifficultyLabel
  # Array of Labels for every options for Difficulty
  attr_reader :cDifficultyOptions
  # Label for In-Game tutorials
  attr_reader :cInGameTutoLabel
  # Label for Return to Title
  attr_reader :cReturnTitleLabel
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    x = 20
    sw = self.contents.width
    dw = sw*2/3 - x
    
    # Window Skins
    @cWindowSkinsLabel = CLabel.new(self, Rect.new(x, WLH/2, sw/3, WLH), 
                                    Vocab::system_window_skin_label, 0, Font.bold_font)
    
    @cWindowSkinsOptions = []
    @cWindowSkinsOptions.push(CLabel.new(self, Rect.new(sw/3, WLH/2, dw/5, WLH), 
                              "", 1))
    @cWindowSkinsOptions.push(CLabel.new(self, Rect.new(sw/3+dw*1/5, WLH/2, dw/5, WLH), 
                              "", 1))                    
    @cWindowSkinsOptions.push(CLabel.new(self, Rect.new(sw/3+dw*2/5, WLH/2, dw/5, WLH), 
                              "", 1))  
    @cWindowSkinsOptions.push(CLabel.new(self, Rect.new(sw/3+dw*3/5, WLH/2, dw/5, WLH), 
                              "", 1))  
    @cWindowSkinsOptions.push(CLabel.new(self, Rect.new(sw/3+dw*4/5, WLH/2, dw/5, WLH), 
                              "", 1))                             
    
    # BGM Volume/BGM Mute
    @ucBGMVolume = UCVolumeControl.new(self, Rect.new(x, WLH*2+WLH/2, sw-x*2, WLH), Vocab::system_bgm_label,
                                       text_color(YE::SYSTEM::BGM_COLOUR1),
                                       text_color(YE::SYSTEM::BGM_COLOUR2),
                                       Color.gauge_back_color, 2, Color.volume_border_color)
    
    # Sound Volume/Sound Mute
    @ucSFXVolume = UCVolumeControl.new(self, Rect.new(x, WLH*4+WLH/2, sw-x*2, WLH), Vocab::system_sfx_label,
                                       text_color(YE::SYSTEM::SFX_COLOUR1),
                                       text_color(YE::SYSTEM::SFX_COLOUR2),
                                       Color.gauge_back_color, 2, Color.volume_border_color)
                         
    # Ambience Volume/Ambience Mute
    @ucBGSVolume = UCVolumeControl.new(self, Rect.new(x, WLH*6+WLH/2, sw-x*2, WLH), Vocab::system_bgs_label,
                                       text_color(YE::SYSTEM::BGS_COLOUR1),
                                       text_color(YE::SYSTEM::BGS_COLOUR2),
                                       Color.gauge_back_color, 2, Color.volume_border_color)
                         
    # Battle Animations
    @cBattleAnimLabel = CLabel.new(self, Rect.new(x, WLH*8, sw/3, WLH), 
                                   Vocab::system_ani_label, 0, Font.bold_font)
    @cBattleAnimOptions = []
    @cBattleAnimOptions.push(CLabel.new(self, Rect.new(sw/3, WLH*8, dw/2, WLH), 
                             Vocab::system_ani_on_command, 1))
    @cBattleAnimOptions.push(CLabel.new(self, Rect.new(sw/3+dw*1/2, WLH*8, dw/2, WLH), 
                             Vocab::system_ani_off_command, 1))
                                   
    # Auto-Dash
    @cAutoDashLabel = CLabel.new(self, Rect.new(x, WLH*9, sw/3, WLH), 
                                 Vocab::system_autodash_label, 0, Font.bold_font)
    @cAutoDashOptions = []
    @cAutoDashOptions.push(CLabel.new(self, Rect.new(sw/3, WLH*9, dw/2, WLH), 
                           Vocab::system_autodash_on_command, 1))
    @cAutoDashOptions.push(CLabel.new(self, Rect.new(sw/3+dw*1/2, WLH*9, dw/2, WLH), 
                           Vocab::system_autodash_off_command, 1))
                             
    # Instant Text
    @cInstantTextLabel = CLabel.new(self, Rect.new(x, WLH*10, sw/3, WLH), 
                                    Vocab::system_instanttext_label, 0, Font.bold_font)
    @cInstantTextOptions = []
    @cInstantTextOptions.push(CLabel.new(self, Rect.new(sw/3, WLH*10, dw/2, WLH), 
                              Vocab::system_instanttext_on_command, 1))
    @cInstantTextOptions.push(CLabel.new(self, Rect.new(sw/3+dw*1/2, WLH*10, dw/2, WLH), 
                              Vocab::system_instanttext_off_command, 1))
    
    # Difficulty
    @cDifficultyLabel = CLabel.new(self, Rect.new(x, WLH*11, sw/3, WLH), 
                                   Vocab::system_difficulty_label, 0, Font.bold_font)
    @cDifficultyOptions = []                             
    @cDifficultyOptions.push(CLabel.new(self, Rect.new(sw/3, WLH*11, dw/3, WLH), 
                             "", 1))
    @cDifficultyOptions.push(CLabel.new(self, Rect.new(sw/3+dw*1/3, WLH*11, dw/3, WLH), 
                             "", 1))
    @cDifficultyOptions.push(CLabel.new(self, Rect.new(sw/3+dw*2/3, WLH*11, dw/3, WLH), 
                             "", 1))
    
    # In-game Tutorials
    @cInGameTutoLabel = CLabel.new(self, Rect.new(x, WLH*12, sw-x, WLH), 
                                   Vocab::system_tutorials_label, 0, Font.bold_font)
    if $game_system.outline_enable == nil ||
       $game_system.outline_enable.size == 0
      @cInGameTutoLabel.active = false
    end
                                   
    # Return to Title
    @cReturnTitleLabel = CLabel.new(self, Rect.new(x, WLH*13, sw-x, WLH), 
                                    Vocab::system_totitle_label, 0, Font.bold_font)
    
    window_update()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update()
    
    # Window Skins
    winvar = $game_variables[YE::SYSTEM::WINDOW_VARIABLE]
    temp = MENU_CONFIG::WINDOW_HASH[winvar - 2] == nil ? nil : MENU_CONFIG::WINDOW_HASH[winvar - 2][0]
    @cWindowSkinsOptions[0].text = temp
    @cWindowSkinsOptions[0].active = false
    temp = MENU_CONFIG::WINDOW_HASH[winvar - 1] == nil ? nil : MENU_CONFIG::WINDOW_HASH[winvar - 1][0]
    @cWindowSkinsOptions[1].text = temp
    @cWindowSkinsOptions[1].active = false
    temp = MENU_CONFIG::WINDOW_HASH[winvar] == nil ? nil : MENU_CONFIG::WINDOW_HASH[winvar][0]
    @cWindowSkinsOptions[2].text = temp
    @cWindowSkinsOptions[2].active = true
    temp = MENU_CONFIG::WINDOW_HASH[winvar + 1] == nil ? nil : MENU_CONFIG::WINDOW_HASH[winvar + 1][0]
    @cWindowSkinsOptions[3].text = temp
    @cWindowSkinsOptions[3].active = false
    temp = MENU_CONFIG::WINDOW_HASH[winvar + 2] == nil ? nil : MENU_CONFIG::WINDOW_HASH[winvar + 2][0]
    @cWindowSkinsOptions[4].text = temp
    @cWindowSkinsOptions[4].active = false
    
    # BGM Volume/BGM Mute
    @ucBGMVolume.update($game_switches[YE::SYSTEM::BGM_MUTE_SWITCH], 
                        $game_variables[YE::SYSTEM::BGM_VOLUME_VAR])
    
    # Sound Volume/Sound Mute
    @ucSFXVolume.update($game_switches[YE::SYSTEM::SFX_MUTE_SWITCH], 
                        $game_variables[YE::SYSTEM::SFX_VOLUME_VAR])
    
    # Ambience Volume/Ambience Mute
    @ucBGSVolume.update($game_switches[YE::SYSTEM::BGS_MUTE_SWITCH], 
                        $game_variables[YE::SYSTEM::BGS_VOLUME_VAR])
    
    # Battle Animations
    if $game_switches[YE::SYSTEM::ANI_SWITCH]
      @cBattleAnimOptions[0].active = true
      @cBattleAnimOptions[1].active = false
    else
      @cBattleAnimOptions[0].active = false
      @cBattleAnimOptions[1].active = true
    end
    
    # Auto-Dash
    if $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH]
      @cAutoDashOptions[0].active = true
      @cAutoDashOptions[1].active = false
    else
      @cAutoDashOptions[0].active = false
      @cAutoDashOptions[1].active = true
    end
    
    # Instant Text
    if $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH]
      @cInstantTextOptions[0].active = true
      @cInstantTextOptions[1].active = false
    else
      @cInstantTextOptions[0].active = false
      @cInstantTextOptions[1].active = true
    end
    
    # Difficulty
    diffvar = $game_variables[KGC::BattleDifficulty::DIFFICULTY_VARIABLE]
    temp = (diffvar - 1) < 0 ? nil : Vocab::difficulty_strings[diffvar - 1]
    @cDifficultyOptions[0].text = temp
    @cDifficultyOptions[0].active = false
    temp = Vocab::difficulty_strings[diffvar] == nil ? nil : Vocab::difficulty_strings[diffvar]
    @cDifficultyOptions[1].text = temp
    @cDifficultyOptions[1].active = true
    temp = (diffvar + 1) > Vocab::difficulty_strings.size-1 ? nil : Vocab::difficulty_strings[diffvar + 1]
    @cDifficultyOptions[2].text = temp
    @cDifficultyOptions[2].active = false
      
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cWindowSkinsLabel.draw()
    @cWindowSkinsOptions.each() { |cOption| cOption.draw() }
    @ucBGMVolume.draw()
    @ucSFXVolume.draw()
    @ucBGSVolume.draw()
    @cBattleAnimLabel.draw()
    @cBattleAnimOptions.each() { |cOption| cOption.draw() }
    @cAutoDashLabel.draw()
    @cAutoDashOptions.each() { |cOption| cOption.draw() }
    @cInstantTextLabel.draw()
    @cInstantTextOptions.each() { |cOption| cOption.draw() }
    @cDifficultyLabel.draw()
    @cDifficultyOptions.each() { |cOption| cOption.draw() }
    @cInGameTutoLabel.draw()
    @cReturnTitleLabel.draw()
  end
  
end
