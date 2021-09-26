#==============================================================================
# ** Scene_End
#------------------------------------------------------------------------------
#  This class replace the game end screen processing by a game system
#  screen processing (change background, volume, tutorials, etc.)
#==============================================================================

class Scene_End < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
   
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : 
  #--------------------------------------------------------------------------
  def initialize(menu_index=nil)
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    if MENU_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(MENU_CONFIG::IMAGE_BG)
      @bg.opacity = MENU_CONFIG::IMAGE_BG_OPACITY
    end
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, YE::SYSTEM::WINDOW_HELP)
    @system_window = Window_System.new(0, 0, 640, 384)
    
    positions = []
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cWindowSkinsLabel.rect.y-12, 
                                      @system_window.width-32, 48)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.ucBGMVolume.cVolumeLabel.rect.y-12, 
                                      @system_window.width-32, 48)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.ucSFXVolume.cVolumeLabel.rect.y-12, 
                                      @system_window.width-32, 48)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.ucBGSVolume.cVolumeLabel.rect.y-12, 
                                      @system_window.width-32, 48)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cBattleAnimLabel.rect.y, 
                                      @system_window.width-32, 24)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cAutoDashLabel.rect.y, 
                                      @system_window.width-32, 24)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cInstantTextLabel.rect.y, 
                                      @system_window.width-32, 24)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cDifficultyLabel.rect.y, 
                                      @system_window.width-32, 24)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cInGameTutoLabel.rect.y, 
                                      @system_window.width-32, 24)))
    positions.push(CursorPosition.new(Rect.new(0, @system_window.cReturnTitleLabel.rect.y, 
                                      @system_window.width-32, 24)))
                                      
    @command_window = Window_Custom_Selectable.new(0, 0, 640, 384, positions, true)
    @command_window.opacity = 0
    @command_window.visible = true
    @command_window.active = true
    @command_window.z = 1000
    if @menu_index != nil
      @command_window.index = @menu_index
      update_help()
    else
      @command_window.index = 0
    end

    @last_index = -1
  end
  
  #--------------------------------------------------------------------------
  # Post-Start Processing
  #--------------------------------------------------------------------------
  def post_start
    super
  end
  
  #--------------------------------------------------------------------------
  # Pre-termination Processing
  #--------------------------------------------------------------------------
  def pre_terminate
    super
  end
  
  #--------------------------------------------------------------------------
  # Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @help_window.dispose if @help_window != nil
    @system_window.dispose if @system_window != nil
    @command_window.dispose if @command_window != nil
  end
  
  #--------------------------------------------------------------------------
  # Update Help
  #--------------------------------------------------------------------------
  def update_help
    text = ""
    case @command_window.index
    when 0; text = Vocab::system_window_skin_help_text
    when 1; text = Vocab::system_bgm_help_text
    when 2; text = Vocab::system_sfx_help_text
    when 3; text = Vocab::system_bgs_help_text
    when 4; text = Vocab::system_ani_help_text
    when 5; text = Vocab::system_autodash_help_text
    when 6; text = Vocab::system_instanttext_help_text
    when 7; text = Vocab::system_difficulty_help_text
    when 8; text = Vocab::system_tutorials_help_text
    when 9; text = Vocab::system_totitle_help_text
    end
    @help_window.window_update(text)
  end
  
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @system_window.update
    @command_window.update

    if @last_index != @command_window.index
      @last_index = @command_window.index
      update_help()
    end
    
    if @command_window.active
      update_command_selection
    else
      case @command_window.index
      when 0
        update_window_skins_selection()
      when 1
        update_volume_selection(YE::SYSTEM::BGM_VOLUME_VAR, YE::SYSTEM::BGM_MUTE_SWITCH)
      when 2
        update_volume_selection(YE::SYSTEM::SFX_VOLUME_VAR, YE::SYSTEM::SFX_MUTE_SWITCH)
      when 3
        update_volume_selection(YE::SYSTEM::BGS_VOLUME_VAR, YE::SYSTEM::BGS_MUTE_SWITCH)
      when 4
        update_option_switch_selection(YE::SYSTEM::ANI_SWITCH)
      when 5
        update_option_switch_selection(YE::SYSTEM::AUTO_DASH_SWITCH)
      when 6
        update_option_switch_selection(YE::SYSTEM::INSTANT_TEXT_SWITCH)
      when 7
        update_option_var_selection(KGC::BattleDifficulty::DIFFICULTY_VARIABLE, 
                                    KGC::BattleDifficulty::DIFFICULTY.size)
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Return to Original Screen
  #--------------------------------------------------------------------------
  def return_scene
    $scene = Scene_Menu.new(6)
  end
  private :return_scene
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      quit_command()

    elsif Input.trigger?(Input::C)
      case @command_window.index
      when 8
        if $game_system.outline_enable == nil ||
           $game_system.outline_enable.size == 0
          Sound.play_buzzer
        else
          Sound.play_decision
          in_game_tutorials_command()
        end
             
      when 9
        Sound.play_decision
        command_to_title()
      else
        Sound.play_decision
        option_command()
      end
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Window Skins Selection
  #--------------------------------------------------------------------------
  def update_window_skins_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
      old_val = $game_variables[YE::SYSTEM::WINDOW_VARIABLE]
      if Input.repeat?(Input::LEFT)
        $game_variables[YE::SYSTEM::WINDOW_VARIABLE] -= 1
        if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] == 0
          $game_variables[YE::SYSTEM::WINDOW_VARIABLE] = 1
        end
      elsif Input.repeat?(Input::RIGHT)
        $game_variables[YE::SYSTEM::WINDOW_VARIABLE] += 1
        if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] > MENU_CONFIG::WINDOW_HASH.size
          $game_variables[YE::SYSTEM::WINDOW_VARIABLE] = MENU_CONFIG::WINDOW_HASH.size
        end
      end
      if old_val != $game_variables[YE::SYSTEM::WINDOW_VARIABLE]
        Sound.play_cursor
        #Recreate windows to use the new font when necessary
        temp = @system_window
        @system_window = Window_System.new(temp.x, temp.y, temp.width, temp.height)
        temp.dispose()
        
        temp = @help_window
        @help_window = Window_Info_Help.new(temp.x, temp.y, 640, 96, YE::SYSTEM::WINDOW_HELP)
        temp.dispose()
      end
    end
  end
  private :update_window_skins_selection
  
  #--------------------------------------------------------------------------
  # * Update Volume Selection
  #--------------------------------------------------------------------------
  def update_volume_selection(vol_var, vol_mute_switch)
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
      if !$game_switches[vol_mute_switch]
        old_val = $game_variables[vol_var] 
        if Input.repeat?(Input::LEFT)
          if Input.press?(Input::A)
            $game_variables[vol_var] += 10
          else
            $game_variables[vol_var] += 1
          end
          if $game_variables[vol_var] >= 100
            $game_variables[vol_var] = 100
          end
        elsif Input.repeat?(Input::RIGHT)
          if Input.press?(Input::A)
            $game_variables[vol_var] -= 10
          else
            $game_variables[vol_var] -= 1
          end
          if $game_variables[vol_var] <= 0
            $game_variables[vol_var] = 0
          end
        end
        if old_val != $game_variables[vol_var]
          Sound.play_cursor
          @system_window.window_update()
          RPG::BGM.last.play
          RPG::BGS.last.play
        end
      end
      
    elsif Input.trigger?(Input::L) || Input.trigger?(Input::R)
      old_val = $game_switches[vol_mute_switch]
      if $game_switches[vol_mute_switch]
        $game_switches[vol_mute_switch] = false
      else
        $game_switches[vol_mute_switch] = true
      end
      if old_val != $game_switches[vol_mute_switch]
        Sound.play_decision
        @system_window.window_update()
        RPG::BGM.last.play
        RPG::BGS.last.play
      end
    end
  end
  private :update_volume_selection
  
  #--------------------------------------------------------------------------
  # * Update Option Switch Selection
  #--------------------------------------------------------------------------
  def update_option_switch_selection(option_switch)
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
      old_val = $game_switches[option_switch]
      if Input.trigger?(Input::LEFT)
        $game_switches[option_switch] = true
      elsif Input.trigger?(Input::RIGHT)
        $game_switches[option_switch] = false
      end
      if old_val != $game_switches[option_switch]
        Sound.play_cursor
        @system_window.window_update()
      end
    end
  end
  private :update_option_switch_selection
  
  #--------------------------------------------------------------------------
  # * Update Option Variable Selection
  #--------------------------------------------------------------------------
  def update_option_var_selection(option_var, max)
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
      old_val = $game_variables[option_var]
      if Input.repeat?(Input::LEFT)
        $game_variables[option_var] -= 1
        if $game_variables[option_var] < 0
          $game_variables[option_var] = 0
        end
      elsif Input.repeat?(Input::RIGHT)
        $game_variables[option_var] += 1
        if $game_variables[option_var] > max-1
          $game_variables[option_var] = max-1
        end
      end
      if old_val != $game_variables[option_var]
        Sound.play_cursor
        @system_window.window_update()
      end
    end
  end
  private :update_option_var_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    return_scene
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Option command
  #--------------------------------------------------------------------------
  def option_command()
    @command_window.active = false
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * In-Game Tutorials command
  #--------------------------------------------------------------------------
  def in_game_tutorials_command()
    $scene = Scene_Outline.new(8, true)
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Process When Choosing [To Title] Command
  #--------------------------------------------------------------------------
  def command_to_title
    RPG::BGM.fade(800)
    RPG::BGS.fade(800)
    RPG::ME.fade(800)
    $scene = Scene_Title.new
    Graphics.fadeout(60)
  end
  private :command_to_title
  
end
