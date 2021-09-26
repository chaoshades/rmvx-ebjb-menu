#==============================================================================
# ** Scene_Skill
#------------------------------------------------------------------------------
#  This class performs the skill screen processing.
#==============================================================================

class Scene_Skill < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background()
    if MENU_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(MENU_CONFIG::IMAGE_BG)
      @bg.opacity = MENU_CONFIG::IMAGE_BG_OPACITY
    end
    
    @actor = $game_party.members[@actor_index]
    
    @char_image_window = Window_Char_Image.new(-16, 56+16, 640, 424, @actor)
    @char_image_window.opacity = 0
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    
    @skill_back_window = Window_Base.new(200, 56, 440, 328)
    @dataviews_window = Window_Dataviews.new(200, 56, 440, 56, MENU_CONFIG::SKILL_DATAVIEWS)
    @dataviews_window.active = false
    @dataviews_window.opacity = 0
    
    @status_window = Window_Skill_Status.new(0, 0, 200, 128, @actor)
    
    @skill_window = Window_Skill.new(200, 96, 440, 272, @actor, @dataviews_window.selected_view)
    @skill_window.opacity = 0
    @skill_window.help_window = @help_window
    
    @skill_details_window = Window_SkillDetails.new(0,384,640,96,nil)
    @skill_details_window.visible = false
    @skill_window.detail_window = @skill_details_window
        
    @target_window = Window_Party_Status.new(140, 0, 480, 424, $game_party.members)
    hide_target_window
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @char_image_window.dispose if @char_image_window != nil
    @status_window.dispose if @status_window != nil
    @dataviews_window.dispose if @dataviews_window != nil
    @skill_details_window.dispose if @skill_details_window != nil
    @skill_back_window.dispose if @skill_back_window != nil
    @skill_window.dispose if @skill_window != nil
    @help_window.dispose if @help_window != nil
    @target_window.dispose if @target_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @char_image_window.update
    @status_window.update
    @skill_window.update
    @dataviews_window.update
    @skill_back_window.update
    @skill_details_window.update
    @help_window.update
    @target_window.update
    if @skill_window.active
      update_skill_selection
    elsif @target_window.active
      update_target_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Skill
  #--------------------------------------------------------------------------
  def determine_skill
    if @skill.for_friend?
      show_target_window(@skill_window.index % 2 == 0)
      if @skill.for_all?
        @target_window.index = 0
        @target_window.cursor_select_all()
      elsif @skill.for_user?
        @target_window.index = @actor_index
        @target_window.block_cursor = true
      else
        if $game_party.last_target_index < @target_window.item_max
          @target_window.index = $game_party.last_target_index
        else
          @target_window.index = 0
        end
      end
    else
      use_skill_nontarget
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Target
  #    If there is no effect (such as using a potion on an incapacitated
  #    character), play a buzzer SE.
  #--------------------------------------------------------------------------
  def determine_target
    used = false
    if @skill.for_all?
      for target in $game_party.members
        target.skill_effect(@actor, @skill)
        used = true unless target.skipped
      end
    elsif @skill.for_user?
      target = $game_party.members[@target_window.index]
      target.skill_effect(@actor, @skill)
      used = true unless target.skipped
    else
      $game_party.last_target_index = @target_window.index
      target = $game_party.members[@target_window.index]
      target.skill_effect(@actor, @skill)
      used = true unless target.skipped
    end
    if used
      use_skill_nontarget
    else
      Sound.play_buzzer
    end
  end
  
  #--------------------------------------------------------------------------
  # * Show Target Window
  #     right : Right justification flag (if false, left justification)
  #--------------------------------------------------------------------------
  def show_target_window(right)
    @skill_window.active = false
    width_remain = (640 - @target_window.width)/2
    @target_window.x = width_remain.floor
    height_remain = (480 - @target_window.height)/2
    @target_window.y = height_remain.floor
    @target_window.visible = true
    @target_window.active = true
  end
  
  #--------------------------------------------------------------------------
  # * Hide Target Window
  #--------------------------------------------------------------------------
  def hide_target_window
    @skill_window.active = true
    @target_window.visible = false
    @target_window.active = false
  end

  #--------------------------------------------------------------------------
  # * Use Skill (apply effects to non-ally targets)
  #--------------------------------------------------------------------------
  def use_skill_nontarget
    Sound.play_use_skill
    @actor.mp -= @actor.calc_mp_cost(@skill)
    @status_window.window_update(@actor)
    @skill_window.window_update(@actor)
    @target_window.window_update($game_party.members)
    if $game_party.all_dead?
      $scene = Scene_Gameover.new
    elsif @skill.common_event_id > 0
      $game_temp.common_event_id = @skill.common_event_id
      $scene = Scene_Map.new
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Skill Selection
  #--------------------------------------------------------------------------
  def update_skill_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor
    elsif Input.trigger?(Input::C)
      @skill = @skill_window.skill
      if @skill != nil
        @actor.last_skill_id = @skill.id
      end
      if @actor.skill_can_use?(@skill)
        Sound.play_decision
        determine_skill
      else
        Sound.play_buzzer
      end
    elsif (Input.repeat?(Input::Y) || Input.repeat?(Input::Z))
      update_dataview_select(Input.press?(Input::Z), 
                             Input.trigger?(Input::Y) || Input.trigger?(Input::Z))
      @skill_window.window_update(@actor, @dataviews_window.selected_view)
      @skill_window.index = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Target Selection
  #--------------------------------------------------------------------------
  def update_target_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      hide_target_window
    elsif Input.trigger?(Input::C)
      if not @actor.skill_can_use?(@skill)
        Sound.play_buzzer
      else
        determine_target
      end
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update dataview selection
  #     isRight : true to move right, else false to move left
  #-------------------------------------------------------------------------- 
  def update_dataview_select(isRight, wrap)
    if isRight
      @dataviews_window.cursor_right(wrap)
    else      
      @dataviews_window.cursor_left(wrap)
    end
  end
  private :update_dataview_select
  
end
