#==============================================================================
# ** Scene_File
#------------------------------------------------------------------------------
#  This class performs the save screen processing.
#==============================================================================

class Scene_File < Scene_Base
  include Wora_NSS
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
   
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     saving     : save flag (if false, load screen)
  #     from_title : flag: it was called from "Continue" on the title screen
  #     from_event : flag: it was called from the "Call Save Screen" event
  #     menu_index : 
  #--------------------------------------------------------------------------
  def initialize(saving, from_title, from_event, menu_index=nil)
    @saving = saving
    @from_title = from_title
    @from_event = from_event
    @menu_index = menu_index
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #-------------------------------------------------------------------------
  # * Start processing
  #-------------------------------------------------------------------------
  def start
    super
    create_menu_background
    if MENU_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(MENU_CONFIG::IMAGE_BG)
      @bg.opacity = MENU_CONFIG::IMAGE_BG_OPACITY
    end
    @help_window = Window_Help.new
    @help_window.width = 640
    @saves_list = []
    (0..MAX_SAVE_SLOT-1).each do |i|
      @saves_list << SaveData.new(SLOT_NAME.clone.gsub!(/\{ID\}/i) { (i+1).to_s }, 
                                  make_filename(i))
    end
    @window_slotdetail = Window_Slot_Details.new(160, 56, 480, 424, nil)
    @window_slotlist = Window_Slot_List.new(0, 56, 160, 424, @saves_list)
    if OPACITY_DEFAULT == false
      @help_window.opacity = NSS_WINDOW_OPACITY
      @window_slotlist.opacity = NSS_WINDOW_OPACITY
      @window_slotdetail.opacity = NSS_WINDOW_OPACITY
    end
    
    @confirm_window = Window_Confirmation.new(220, 212, SFC_Window_Width, 
                                              Vocab::confirm_save_text,
                                              Vocab::confirm_yes_text,
                                              Vocab::confirm_no_text)
    @confirm_window.active = false
    @confirm_window.visible = false
    
    # Create Folder for Save file
    if SAVE_PATH != ''
      Dir.mkdir(SAVE_PATH) if !FileTest.directory?(SAVE_PATH)
    end
    if @saving
      @index = $game_temp.last_file_index
      @help_window.set_text(Vocab::SaveMessage)
    else
      @index = latest_file_index()
      @help_window.set_text(Vocab::LoadMessage)
    end
    @window_slotlist.index = @index
    # Draw Information
    @last_slot_index = @window_slotlist.index
    @window_slotdetail.window_update(@saves_list[@last_slot_index])
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
    @window_slotlist.dispose if @window_slotlist != nil
    @window_slotdetail.dispose if @window_slotdetail != nil
    @help_window.dispose if @help_window != nil
    @confirm_window.dispose if @confirm_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @confirm_window.update
    @window_slotlist.update
    @window_slotdetail.update
    @help_window.update
    
    if @confirm_window.active
      update_confirm_action()
    elsif @window_slotlist.active
      if @window_slotlist.index != @last_slot_index
        @last_slot_index = @window_slotlist.index
        @window_slotdetail.window_update(@saves_list[@last_slot_index])
      end
      update_savefile_selection()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Return to Original Screen
  #--------------------------------------------------------------------------
  def return_scene
    if @menu_index != nil
      $scene = Scene_Menu.new(@menu_index)
    elsif @from_title
      $scene = Scene_Title.new
    elsif @from_event
      $scene = Scene_Map.new
    else
      $scene = Scene_Map.new
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Save File Selection
  #--------------------------------------------------------------------------
  def update_savefile_selection
    if Input.trigger?(Input::C)
      determine_savefile()
    elsif Input.trigger?(Input::B)
      Sound.play_cancel
      quit_command()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Confirm Action
  #--------------------------------------------------------------------------
  def update_confirm_action()
    if Input.trigger?(Input::C)
      case @confirm_window.index
      when 0
        Sound.play_save
        do_save()
        @confirm_window.hide()
        @window_slotlist.active=true
      when 1
        Sound.play_cancel
        @confirm_window.hide()
        @window_slotlist.active=true
      end
    elsif Input.trigger?(Input::B)
      Sound.play_cancel
      @confirm_window.hide()
      @window_slotlist.active=true
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene Commands
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Quit command
  #--------------------------------------------------------------------------
  def quit_command()
    return_scene
  end
  private :quit_command
  
  #--------------------------------------------------------------------------
  # * Execute Save
  #--------------------------------------------------------------------------
  def do_save 
    file = File.open(make_filename(@last_slot_index), "wb")
    write_save_data(file)
    file.close
    $game_temp.last_file_index = @last_slot_index
    if SCENE_CHANGE
      return_scene
    else
      $scene = Scene_File.new(true, false, false, @menu_index)
    end
  end
  private:do_save
  
  #--------------------------------------------------------------------------
  # * Execute Load
  #--------------------------------------------------------------------------
  def do_load
    file = File.open(make_filename(@last_slot_index), "rb")
    read_save_data(file)
    file.close
    $game_temp.last_file_index = @last_slot_index
    $scene = Scene_Map.new
    RPG::BGM.fade(1500)
    Graphics.fadeout(60)
    Graphics.wait(40)
    @last_bgm.play
    @last_bgs.play
  end
  private:do_load
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Confirm Save File
  #--------------------------------------------------------------------------
  def determine_savefile
    if @saving
      if FileTest.exist?(make_filename(@last_slot_index))
        Sound.play_decision
        @confirm_window.show()
        @window_slotlist.active=false
      else
        Sound.play_save
        do_save()
      end
    else
      if FileTest.exist?(make_filename(@last_slot_index))
        Sound.play_load
        do_load()
      else
        Sound.play_buzzer
      end
    end
  end
  private :determine_savefile
  
  #--------------------------------------------------------------------------
  # * Create Filename
  #     file_index : save file index (0-3)
  #--------------------------------------------------------------------------
  def make_filename(file_index)
    return SAVE_PATH + SAVE_FILE_NAME.gsub(/\{ID\}/i) { (file_index + 1).to_s }
  end
  private :make_filename
  
  #--------------------------------------------------------------------------
  # * Select File With Newest Timestamp
  #--------------------------------------------------------------------------
  def latest_file_index
    latest_index = 0
    latest_time = Time.at(0)
    (0..MAX_SAVE_SLOT-1).each do |i|
      filename = make_filename(i)
      next if !FileTest.exist?(filename)
      file_time = File.mtime(filename)
      if file_time > latest_time
        latest_time = file_time
        latest_index = i
      end
    end
    return latest_index
  end
  private :latest_file_index
  
  #--------------------------------------------------------------------------
  # * Alias write save data
  #     file : write file object (opened)
  #--------------------------------------------------------------------------
  alias write_save_data_ebjb write_save_data unless $@
  def write_save_data(file)
    write_save_data_ebjb(file)
    Marshal.dump(Bitmap.make_png($game_temp.orig_background_bitmap),         file)
  end
  private :write_save_data
  
end
