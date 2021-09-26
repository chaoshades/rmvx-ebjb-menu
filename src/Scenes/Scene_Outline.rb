#==============================================================================
# ** Scene_Outline
#------------------------------------------------------------------------------
# Plot Summary Scene Class  
#==============================================================================

class Scene_Outline < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
   
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : 
  #--------------------------------------------------------------------------
  def initialize(menu_index=nil, from_system=false)
    @menu_index = menu_index
    @from_system = from_system
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
        
    @title_window = Window_Outline_Title.new(0, 0, 640, 56)
    @content_window = Window_Outline.new(0, 56, 640, 424)
    
    # Create Window   
    @list_window = Window_Outline_List.new(0, 0, 400, 400, Vocab::tutorials_strings)
    width_remain = (640 - @list_window.width)/2
    @list_window.x = width_remain.floor
    height_remain = (480 - @list_window.height)/2
    @list_window.y = height_remain.floor
  end
  
  #--------------------------------------------------------------------------
  # * Termination Processing
  #--------------------------------------------------------------------------
  def terminate
    super
    dispose_menu_background()
    # Dispose
    unless @bg.nil?
      @bg.bitmap.dispose
      @bg.dispose
    end
    @list_window.dispose if @list_window != nil
    @title_window.dispose if @title_window != nil
    @content_window.dispose if @content_window != nil
  end

  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    # Update Windows
    @list_window.update
    @title_window.update
    @content_window.update
    
    # Operate Active Window
    if @list_window.active
      update_list_selection()
    elsif @content_window.active
      update_outline_selection()
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Return to Original Screen
  #--------------------------------------------------------------------------
  def return_scene
    if @menu_index != nil
      if @from_system
        $scene = Scene_End.new(@menu_index)
      else
        $scene = Scene_Menu.new(@menu_index)
      end
    else
      # Call Map
      $scene = Scene_Map.new
    end
  end
  private :return_scene
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Frame (List)
  #--------------------------------------------------------------------------
  def update_list_selection
    # If B Button is Pressed 
    if Input.trigger?(Input::B)
      # Play cancel SE
      Sound.play_cancel
      quit_command()

    # If C Button is Pressed 
    elsif Input.trigger?(Input::C)
      outline = @list_window.selected_outline
      # If you cannot view...
      if outline.contents == nil
        # Play buzzer SE
        Sound.play_buzzer
      else
        # Play decision SE
        Sound.play_decision
        outline_command()
      end
    end
  end
  private :update_list_selection
  
  #--------------------------------------------------------------------------
  # * Frame Update (Text)
  #--------------------------------------------------------------------------
  def update_outline_selection
    # If B Button is Pressed 
    if Input.trigger?(Input::B)
      # Play cancel SE
      Sound.play_cancel
      cancel_command()
    end
  end
  private :update_outline_selection
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Cancel command
  #--------------------------------------------------------------------------
  def cancel_command()
    # Switch Window
    @list_window.active = true
    @list_window.visible = true
    @content_window.active = false
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
  # * Outline command
  #--------------------------------------------------------------------------
  def outline_command()
    # Update Plot Summary 
    @title_window.window_update(@list_window.selected_outline.title)
    @content_window.window_update(@list_window.selected_outline.contents)
    # Switch Window
    @list_window.active = false
    @list_window.visible = false
    @content_window.active = true
  end
  private :outline_command
  
end
