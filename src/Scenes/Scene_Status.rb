#==============================================================================
# ** Scene_Status
#------------------------------------------------------------------------------
#  This class performs the status screen processing.
#==============================================================================

class Scene_Status < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def initialize(actor_index = 0)
    @actor_index = actor_index
  end
  
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
    
    @status_window = Window_Status.new(200, 40, 440, 440, @actor)
    
    @status_equip_window = Window_Status_Equip.new(415, 40, 225, 272, @actor)
    @status_equip_window.active = false
    
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false
    @item_details_window = Window_ItemDetails.new(0,384,640,96,nil)
    @item_details_window.visible = false
    
    positions = []
    positions.push(CursorPosition.new(Rect.new(@status_equip_window.x,
                            @status_equip_window.y, 
                            @status_equip_window.width-32, 
                            @status_equip_window.height-32)))
    
    @command_window = Window_Custom_Selectable.new(0, 0, 640, 480, positions)
    @command_window.opacity = 0
    @command_window.visible = true
    @command_window.active = true
    @command_window.index = 0
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    @help_window.visible = false
    
    @status_equip_window.help_window = @help_window
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background()
    
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @char_info_window.dispose if @char_info_window != nil
    @char_image_window.dispose if @char_image_window != nil
    @status_window.dispose if @status_window != nil
    @status_equip_window.dispose if @status_equip_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
    @item_details_window.dispose if @item_details_window != nil
    @help_window.dispose if @help_window != nil
    @command_window.dispose if @command_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @char_info_window.update
    @char_image_window.update
    @status_window.update
    @status_equip_window.update
    @equip_details_window.update
    @item_details_window.update
    @help_window.update
    @command_window.update
    
    if @command_window.active
      update_command_selection()
    elsif @status_equip_window.active
      update_equip_selection()
    end
  end
    
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Detail window depending of the type of the drop item
  #     item : item object
  #-------------------------------------------------------------------------- 
  def update_detail_window(item)    
    if item.is_a?(RPG::Item)
      @status_equip_window.detail_window = @item_details_window
    else
      @status_equip_window.detail_window = @equip_details_window
    end
  end
  private :update_detail_window
  
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
      when 0  # Equip
        Sound.play_decision
        equip_command()
        update_detail_window(@status_equip_window.selected_item)
      end
      
    elsif Input.trigger?(Input::R)
      Sound.play_cursor
      next_actor_command()
    elsif Input.trigger?(Input::L)
      Sound.play_cursor
      prev_actor_command()
    end
    
  end
  private :update_command_selection
  
  #--------------------------------------------------------------------------
  # * Update Equip Selection
  #--------------------------------------------------------------------------
  def update_equip_selection()
    if Input.trigger?(Input::B)
      Sound.play_cancel
      cancel_command()
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP)
      update_detail_window(@status_equip_window.selected_item)
    end
  end
  private :update_equip_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    @command_window.active = false
    $scene = Scene_Menu.new(3)
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    @command_window.active = true
    @status_equip_window.active = false
    @item_details_window.window_update(nil)
    @item_details_window.visible = false
    @equip_details_window.window_update(nil)
    @equip_details_window.visible = false
    @help_window.window_update("")
    @help_window.visible = false
  end
  private :cancel_command
  
  #--------------------------------------------------------------------------
  # * Equip command
  #--------------------------------------------------------------------------
  def equip_command()
    @command_window.active = false
    @status_equip_window.active = true
    @status_equip_window.call_update_help()
    @help_window.visible = true
  end
  private :equip_command
  
  #--------------------------------------------------------------------------
  # * Switch to Next Actor Screen command
  #--------------------------------------------------------------------------
  def next_actor_command()
    @actor_index += 1
    @actor_index %= $game_party.members.size
    $scene = Scene_Status.new(@actor_index)
  end
  private :next_actor_command
  
  #--------------------------------------------------------------------------
  # * Switch to Previous Actor Screen command
  #--------------------------------------------------------------------------
  def prev_actor_command()
    @actor_index += $game_party.members.size - 1
    @actor_index %= $game_party.members.size
    $scene = Scene_Status.new(@actor_index)
  end
  private :prev_actor_command
  
end
