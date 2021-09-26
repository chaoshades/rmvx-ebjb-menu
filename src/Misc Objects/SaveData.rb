#==============================================================================
# ** SaveData
#------------------------------------------------------------------------------
#  Represents the data that is saved in a save slot
#==============================================================================

class SaveData
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Save slot name
  attr_reader :slot_name
  # Time on which the save was done
  attr_reader :time
  # characters list based on the $game_party.members that was saved
  attr_reader :characters
  # Graphics.frame_count that was saved
  attr_reader :frame_count
  # RPG::BGM::last that was saved
  attr_reader :last_bgm
  # RPG::BGS::last that was saved
  attr_reader :last_bgs
  # $game_system object that was saved
  attr_reader :game_sys
  # $game_message object that was saved
  attr_reader :game_mes
  # $game_switches object that was saved
  attr_reader :game_swi
  # $game_variables object that was saved
  attr_reader :game_var
  # $game_self_switches object that was saved
  attr_reader :game_self_swi
  # $game_actors object that was saved
  attr_reader :game_act
  # $game_party object that was saved
  attr_reader :game_par
  # $game_troop object that was saved
  attr_reader :game_troop
  # $game_map object that was saved
  attr_reader :game_map
  # $game_player object that was saved
  attr_reader :game_pla
  # Binary stream of the screenshot image
  attr_reader :screenshot_stream
  # True if the save is used, else false
  attr_reader :used
    
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     slot_name : save slot name
  #     filename : save filename
  #--------------------------------------------------------------------------
  def initialize(slot_name, filename)
    @slot_name = slot_name
    if FileTest.exist?(filename)
      @used = true
      # Start load data
      file = File.open(filename, "r")
      @time = file.mtime
      @characters = Marshal.load(file)
      @frame_count = Marshal.load(file)
      @last_bgm = Marshal.load(file)
      @last_bgs = Marshal.load(file)
      @game_sys = Marshal.load(file)
      @game_mes = Marshal.load(file)
      @game_swi = Marshal.load(file)
      @game_var = Marshal.load(file)
      @game_self_swi = Marshal.load(file)
      @game_act = Marshal.load(file)
      @game_par = Marshal.load(file)
      @game_tro = Marshal.load(file)
      @game_map = Marshal.load(file)
      @game_pla = Marshal.load(file)
      @screenshot_stream = Marshal.load(file)
      file.close
    else
      @used = false
    end
  end
  
end
