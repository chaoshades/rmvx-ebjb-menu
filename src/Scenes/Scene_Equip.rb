#==============================================================================
# ** Scene_Equip
#------------------------------------------------------------------------------
#  This class performs the equipment screen processing.
#==============================================================================

class Scene_Equip < Scene_Base
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
    @char_info_window = Window_Char_Info.new(0, 0, 200, 128, @actor)
    @char_info_window.ucExp.visible = false
    @char_info_window.ucExpGauge.visible = false
    @char_info_window.ucTotalExp.visible = false
    @char_info_window.refresh()

    @item_window = Window_Equip_Item.new(425, 40, 215, 272 + 72, @actor, @equip_index)
    @item_window.active = false
    @item_window.index = -1
    @item_window.window_update($game_party.items)
    
    @equip_window = Window_Status_Equip.new(200, 40, 225, 272, @actor)
    @equip_window.active = false
    @equip_window.height = @equip_window.height + 72
    @equip_window.index = @equip_index

    @status_window = Window_Equip_Compare_Status.new(200, 40, 225, 344, @actor)
    @status_window.active = false 
    @status_window.visible = false
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    @equip_window.help_window = @help_window
    @item_window.help_window = @help_window
        
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false
    @equip_window.detail_window = @equip_details_window
    @item_window.detail_window = @equip_details_window
        
    @command_window = Window_Command.new(200, 
                                         [Vocab::equip_command, 
                                          Vocab::equip_optimize_command, 
                                          Vocab::equip_remove_command,
                                          Vocab::equip_remove_all_command], 2)
    @command_window.opacity = 0
    @command_window.x = 0
    @command_window.y = 48
    @command_window.active = true
    
    @optimize_modes_window = Window_Optimize_Modes.new(0, 0, 400, 64, MENU_CONFIG::OPTIMIZE_MODES)
    @optimize_modes_window.visible = false
    @optimize_modes_window.active = false
    @optimize_modes_window.help_window = @help_window
    
    @optimize_modes_window_headers = Window_Selectable_Headers.new(@optimize_modes_window)
    width_remain = (640 - @optimize_modes_window_headers.width)/2
    @optimize_modes_window_headers.x = width_remain.floor
    height_remain = (480 - @optimize_modes_window_headers.height)/2
    @optimize_modes_window_headers.y = height_remain.floor
    @optimize_modes_window_headers.visible = false
    @optimize_modes_window_headers.addHeader(Vocab::optimize_mode_text, 
                                             0, @optimize_modes_window.contents.width, 
                                             1, Font.optimize_mode_header_font)
    @optimize_modes_window_headers.refresh()
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
    @char_info_window.dispose if @char_info_window != nil
    @equip_window.dispose if @equip_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
    @status_window.dispose if @status_window != nil
    @help_window.dispose if @help_window != nil
    @command_window.dispose if @command_window != nil
    @optimize_modes_window_headers.dispose if @optimize_modes_window_headers != nil
    @optimize_modes_window.dispose if @optimize_modes_window != nil
    @item_window.dispose if @item_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @char_image_window.update
    @char_info_window.update
    @help_window.update
    @command_window.update
    @optimize_modes_window_headers.update
    @optimize_modes_window.update
    @equip_window.update
    @equip_details_window.update
    @item_window.update
    @status_window.update
    if @command_window.active
      update_command_selection
    elsif @optimize_modes_window.active
      update_optimize_mode_selection
    elsif @equip_window.active
      update_equip_selection
    elsif @item_window.active
      update_item_selection
    end
  end
  
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
      if @actor.fix_equipment
        Sound.play_buzzer
      else
        case @command_window.index
        when 0  # Equip
          Sound.play_decision
          equip_command()
        when 1  # Optimize
          Sound.play_decision
          optimize_command()
        when 2  # Remove
          Sound.play_decision
          remove_command()
        when 3  # Remove All
          Sound.play_decision
          removeAll_command()
        end
      end
      
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Equip Region Selection
  #--------------------------------------------------------------------------
  def update_equip_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
      
    elsif Input.trigger?(Input::C)
      if @remove
        if @equip_window.selected_item != nil
          Sound.play_decision
          remove_equip_command()
        else
          Sound.play_buzzer
        end
      else
        if @item_window.hasItems
          Sound.play_decision
          do_equip_command()
        else
          Sound.play_buzzer
        end
      end
      
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP)
      @item_window.equip_type = @equip_window.index
      @item_window.window_update($game_party.items)
      @item_window.index = -1
    end
  end
  private :update_equip_selection
    
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_equip_command()
    elsif Input.trigger?(Input::C)
      Sound.play_equip
      change_equip_command()
      cancel_equip_command()
      
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP) 
      @status_window.window_update(@equip_window.index, @item_window.selected_item)
    end
  end
  private :update_item_selection
  
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_optimize_mode_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.trigger?(Input::C)
      Sound.play_equip
      optimize_equip_command(@optimize_modes_window.selected_mode)
      cancel_command()
    end
  end
  private :update_optimize_mode_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @optimize_modes_window_headers.visible = false
    @optimize_modes_window.active = false
    @optimize_modes_window.visible = false
    @status_window.window_update(nil, nil)
    @status_window.active = false
    @status_window.visible = false
    @remove = false
    @equip_window.active = false
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
    @help_window.window_update("")
    @help_window.visible = true
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
  # * Equip command
  #--------------------------------------------------------------------------
  def equip_command()
    @command_window.active = false
    @equip_window.active = true
    @equip_window.call_update_help()
    @item_window.equip_type = @equip_window.index
    @item_window.window_update($game_party.items)
  end
  private :equip_command
  
  #--------------------------------------------------------------------------
  # * Remove command
  #--------------------------------------------------------------------------
  def remove_command()
    @remove = true
    @command_window.active = false
    @equip_window.active = true
    @equip_window.call_update_help()
  end
  private :remove_command
  
  #--------------------------------------------------------------------------
  # * Remove All command
  #--------------------------------------------------------------------------
  def removeAll_command()
    for i in 0...EQUIP_TYPE_MAX
      @actor.change_equip(i, nil)
    end
    @equip_window.window_update(@actor)
    @item_window.equip_type = @equip_window.index
    @item_window.window_update($game_party.items)
  end
  private :removeAll_command
  
  #--------------------------------------------------------------------------
  # * Optimize command
  #--------------------------------------------------------------------------
  def optimize_command()
    @command_window.active = false
    @optimize_modes_window_headers.visible = true
    @optimize_modes_window.visible = true
    @optimize_modes_window.active = true
    @optimize_modes_window.call_update_help()
  end
  private :optimize_command
  
  #--------------------------------------------------------------------------
  # * Remove equip command
  #--------------------------------------------------------------------------
  def remove_equip_command()
    @actor.change_equip(@equip_window.index, nil)
    @equip_window.window_update(@actor)
    @item_window.equip_type = @equip_window.index
    @item_window.window_update($game_party.items)
  end
  private :remove_equip_command
  
  #--------------------------------------------------------------------------
  # * Do equip command
  #--------------------------------------------------------------------------
  def do_equip_command()
    @equip_window.active = false
    @equip_window.visible = false
    @item_window.active = true
    @item_window.index = 0
    @status_window.visible = true
    @status_window.active = true 
    @status_window.window_update(@equip_window.index, @item_window.selected_item)
    @item_window.call_update_help()
  end
  private :do_equip_command
  
  #--------------------------------------------------------------------------
  # * Cancel equip command
  #--------------------------------------------------------------------------
  def cancel_equip_command()
    @item_window.active = false
    @item_window.index = -1
    @status_window.active = false
    @status_window.visible = false
    @status_window.window_update(nil, nil)
    @equip_window.visible = true
    @equip_window.active = true
    @equip_window.call_update_help()
  end
  private :cancel_equip_command
  
  #--------------------------------------------------------------------------
  # * Change equip command
  #--------------------------------------------------------------------------
  def change_equip_command()
    @actor.change_equip(@equip_window.index, @item_window.selected_item)
    @equip_window.window_update(@actor)
    @item_window.equip_type = @equip_window.index
    @item_window.window_update($game_party.items)
  end
  private :change_equip_command
  
  #--------------------------------------------------------------------------
  # * Optimize equip command
  #--------------------------------------------------------------------------
  def optimize_equip_command(optimize_mode)
    best_equipment = []
    
    # Remove current equipment
    for i in 0...EQUIP_TYPE_MAX
      @actor.change_equip(i, nil)
      best_equipment[i] = [-1, nil]
    end
    
    # Keeps a clone with no equipment (to be able to equip items directly below)
    empty_actor = @actor.clone
    # Test equipment with a clone to compare stats
    compare_actor = empty_actor.clone
    
    best_two_handed_weapon = [-1, nil]
    equip_type = -1
    # Find best equipment
    for item in $game_party.items       
      if @actor.equippable?(item)
        if item.is_a?(RPG::Weapon)
          equip_type = 0
        elsif item.is_a?(RPG::Armor)
          equip_type = item.kind + 1
        end
          
        compare_actor.change_equip(equip_type, item, true)
        
        item_score = optimize_mode.calc_optimize_score(empty_actor, compare_actor)
        
        if item.is_a?(RPG::Weapon)
          if item.two_handed
            if item_score > best_two_handed_weapon[0]
              best_two_handed_weapon = [item_score, item]
            end
          elsif @actor.two_swords_style
            if item_score > best_equipment[equip_type][0]
              if $game_party.item_number(item) >= 2
                best_equipment[equip_type+1] = [item_score, item]
              else
                best_equipment[equip_type+1] = best_equipment[equip_type]
              end
              best_equipment[equip_type] = [item_score, item]
            elsif item_score > best_equipment[equip_type+1][0]
              best_equipment[equip_type+1] = [item_score, item]
            end
          else
            if item_score > best_equipment[equip_type][0]
              best_equipment[equip_type] = [item_score, item]
            end
          end
        else
          if item_score > best_equipment[equip_type][0]
            best_equipment[equip_type] = [item_score, item]
          end
        end
        
        # Remove item to reinitialize the equipment of the clone
        compare_actor.change_equip(equip_type, nil, true)
      end
    end
    
    # Equip best equipment
    start = 0
    if best_two_handed_weapon[0] > (best_equipment[0][0] + best_equipment[1][0])
      @actor.change_equip(0, best_two_handed_weapon[1])
      # To skip weapon & shield since the best weapon is the two_handed one
      start = 2
    end
    
    for i in start .. best_equipment.size-1
      @actor.change_equip(i, best_equipment[i][1])
    end
    
    @equip_window.window_update(@actor)
    @item_window.equip_type = @equip_window.index
    @item_window.window_update($game_party.items)
  end
  private :optimize_equip_command
  
end
