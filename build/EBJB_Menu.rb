################################################################################
#                   EBJB Custom Menu System - EBJB_Menu               #   VX   #
#                          Last Update: 2012/03/15                    ##########
#                         Creation Date: 2011/06/25                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts changing the main windows of the menu in your game  #
#  and new features :                                                          #
#  - Save & Load game with a more detailed view (based on Neo Save System V)   #
#  - System window for different in-game options (based on YERD_MenuSystem     #
#    and KGC_Outline)                                                          #
#  - Sorting by different attribute of an item in the inventory                #
#  - Show the newest items in the inventory                                    #
#  - More detailed description of the new equip is shown in the Equip window   #
#  - More detailed info are shown when browsing items or skills                #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the Menu_Config class. For     #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Map - initialize                                                #
#  Alias: Game_Party - initialize, gain_item                                   #
#  Alias: Game_Temp - initialize                                               #
#  Alias: Scene_File - write_save_data                                         #
#  Alias: Window_Base - initialize                                             #
#  Alias: BaseItemComparer - compare                                           #
#  Alias: UsableItemFilter - apply                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_Menu"] = true

#==============================================================================
# ** MENU_CONFIG
#------------------------------------------------------------------------------
#  Contains the custom menu configuration
#==============================================================================

class Font
  #--------------------------------------------------------------------------
  # * Get Font Default settings
  #--------------------------------------------------------------------------
  def self.default_settings
    return [Font.default_bold,
            Font.default_italic,
            Font.default_shadow,
            Font.default_size,
            Font.default_name]
  end
end

module EBJB
  
  #==============================================================================
  # ** Dataview
  #------------------------------------------------------------------------------
  #  Represents a dataview (filters or comparers)
  #==============================================================================

  class Dataview
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Filter or Comparer object
    attr_reader :view
    # Icon index for the dataview
    attr_reader :icon_index
#~     # Label for the dataview
#~     attr_reader :label
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the name of the dataview
    #--------------------------------------------------------------------------
    def label()
      if @v_index == nil
        return nil
      else
        return Vocab::dataviews_strings[@v_index]
      end
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     view : Filter or Comparer object
    #     icon_index : icon index
    #     v_index : index in the Vocab to get name and description of the battle formation
    #--------------------------------------------------------------------------
    def initialize(view, icon_index=nil, v_index=nil)
      @view = view
      @icon_index = icon_index
#~       @label = label
      @v_index = v_index
    end
    
  end
  
  #==============================================================================
  # ** Actor_Body_Image
  #------------------------------------------------------------------------------
  #  Represents an actor's body image
  #==============================================================================

  class Actor_Body_Image
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
    # Filename containing the actor's body image
    attr_reader :filename
    # Rectangle of the image to get in the file
    attr_reader :src_rect
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     filename : filename containing the actor's body image
    #     src_rect : rectangle of the image to get in the file
    #--------------------------------------------------------------------------
    def initialize(filename, src_rect)
      @filename = filename
      @src_rect = src_rect
    end
    
  end
  
  #==============================================================================
  # ** Optimize_Mode
  #------------------------------------------------------------------------------
  #  Represents an optimize mode
  #==============================================================================

  class Optimize_Mode
    
    #//////////////////////////////////////////////////////////////////////////
    # * Attributes
    #//////////////////////////////////////////////////////////////////////////
    
#~     # Name of the mode
#~     attr_reader :name
#~     # Description of the mode
#~     attr_reader :description
    # Array of options that describes how to optimize
    attr_reader :mode
    
    #//////////////////////////////////////////////////////////////////////////
    # * Properties
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Get the name of the optimize mode
    #--------------------------------------------------------------------------
    def name()
      return Vocab::optimize_modes_strings[@v_index][0]
    end
    
    #--------------------------------------------------------------------------
    # * Get the description of the optimize mode
    #--------------------------------------------------------------------------
    def description()
      return Vocab::optimize_modes_strings[@v_index][1]
    end
    
    #//////////////////////////////////////////////////////////////////////////
    # * Constructors
    #//////////////////////////////////////////////////////////////////////////
    
    #--------------------------------------------------------------------------
    # * Object Initialization
    #     v_index : index in the Vocab to get name and description of the battle formation
    #     mode : array of options that describes how to optimize
    #--------------------------------------------------------------------------
    def initialize(v_index, mode)
      @v_index = v_index
#~       @name = name
#~       @description = description
      @mode = mode
    end
    
    #--------------------------------------------------------------------------
    # * Calculate the optimize score of the optimize mode
    #     actor : actor object
    #     compare_actor : actor object to compare with
    #--------------------------------------------------------------------------
    def calc_optimize_score(actor, compare_actor)
      score = 0
      total_score = 0
      
      score = compare_actor.maxhp - actor.maxhp
      if @mode.include?(MENU_CONFIG::OPTIMIZE_HP)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.maxmp - actor.maxmp
      if @mode.include?(MENU_CONFIG::OPTIMIZE_MP)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.atk - actor.atk
      if @mode.include?(MENU_CONFIG::OPTIMIZE_ATK)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.def - actor.def
      if @mode.include?(MENU_CONFIG::OPTIMIZE_DEF)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.spi - actor.spi
      if @mode.include?(MENU_CONFIG::OPTIMIZE_SPI)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.agi - actor.agi
      if @mode.include?(MENU_CONFIG::OPTIMIZE_AGI)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.eva - actor.eva
      if @mode.include?(MENU_CONFIG::OPTIMIZE_EVA)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.hit - actor.hit
      if @mode.include?(MENU_CONFIG::OPTIMIZE_HIT)
        score *= 2
      end
      total_score += score
      
      score = compare_actor.cri - actor.cri
      if @mode.include?(MENU_CONFIG::OPTIMIZE_CRI)
        score *= 2
      end
      total_score += score
      
      return total_score
    end
    
  end
  
  module MENU_CONFIG
    
    # Background image filename, it must be in folder Pictures
    IMAGE_BG = ""
    # Opacity for background image
    IMAGE_BG_OPACITY = 255
    # See WINDOW_HASH for all windows opacity
    
    #------------------------------------------------------------------------
    # Generic patterns
    #------------------------------------------------------------------------
    
    # Gauge pattern
    GAUGE_PATTERN = "%d/%d"
    # Percentage pattern
    PERCENTAGE_PATTERN = "%d%"
    # Time pattern
    TIME_PATTERN = "%02d:%02d:%02d"
    # Max EXP gauge value
    MAX_EXP_GAUGE_VALUE = "-------/-------"    
    
    #------------------------------------------------------------------------
    # Menu Status Window related
    #------------------------------------------------------------------------

    # Number of icons to show at the same time
    ACT_STATES_MAX_ICONS = 4
    # Timeout in seconds before switching icons
    ACT_STATES_ICONS_TIMEOUT = 1
    
    # Icon for EXP
    ICON_EXP  = 102
    # Icon for Level
    ICON_LVL  = 132
    # Icon for TOTAL EXP
    ICON_TOTAL_EXP  = 62
    
    # Icon for HP
    ICON_HP  = 99
    # Icon for MP
    ICON_MP  = 100
    # Icon for ATK
    ICON_ATK  = 2
    # Icon for DEF
    ICON_DEF  = 52
    # Icon for SPI
    ICON_SPI  = 21
    # Icon for AGI
    ICON_AGI  = 48
    # Icon for EVA
    ICON_EVA  = 158
    # Icon for HIT
    ICON_HIT  = 135
    # Icon for CRI
    ICON_CRI  = 119
    
    #------------------------------------------------------------------------
    # Dataview Window related
    #------------------------------------------------------------------------
    
    # DATAVIEWS used with Scene_Item
    ITEM_DATAVIEWS = []
    ITEM_DATAVIEWS.push(Dataview.new(BaseItemComparer.new("new"), nil, 0))
    ITEM_DATAVIEWS.push(Dataview.new(BaseItemComparer.new("type"), nil, 1))
    ITEM_DATAVIEWS.push(Dataview.new(BaseItemComparer.new("name"), nil, 2))
    ITEM_DATAVIEWS.push(Dataview.new(BaseItemComparer.new("name", 1), nil, 3))
    ITEM_DATAVIEWS.push(Dataview.new(WeaponFilter.new(), 2))
    ITEM_DATAVIEWS.push(Dataview.new(ArmorFilter.new("kind", 2), 40))
    ITEM_DATAVIEWS.push(Dataview.new(ArmorFilter.new("kind", 0), 52))
    ITEM_DATAVIEWS.push(Dataview.new(ArmorFilter.new("kind", 1), 32))
    ITEM_DATAVIEWS.push(Dataview.new(ArmorFilter.new("kind", 3), 57))
    ITEM_DATAVIEWS.push(Dataview.new(UsableItemFilter.new(), 64))
    ITEM_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("key"), 83))
    
    # DATAVIEWS used with Scene_Skill
    SKILL_DATAVIEWS = []
    SKILL_DATAVIEWS.push(Dataview.new(SkillComparer.new("mp_cost"), nil, 4))
    SKILL_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("physical_attack", true), 131))
    SKILL_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("physical_attack", false), 119))
    SKILL_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("healing", true), 128))
    SKILL_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("support", true), 137))
    SKILL_DATAVIEWS.push(Dataview.new(UsableItemFilter.new("attack", true), 135))
    
    #------------------------------------------------------------------------
    # Item Window related
    #------------------------------------------------------------------------
    # Items ID that are key items
    KEY_ITEMS_ID = [21, 22]
    
    # Maximum number of different newest items to keep trace of
    MAX_NEWEST_ITEMS = 10
    # Pattern used to show the item quantity in the inventory
    ITEM_NUMBER_PATTERN = ":%2d"
    
    #------------------------------------------------------------------------
    # Skill Window related
    #------------------------------------------------------------------------
    
    # Pattern used to show the skill cost in the skill window
    SKILL_COST_PATTERN = "%4d"
    
    #------------------------------------------------------------------------
    # Scene Equip related
    #------------------------------------------------------------------------
    
    # Unique ids used to represent optimize modes
    # STATS = 10xx
    OPTIMIZE_HP = 1001
    OPTIMIZE_MP = 1002
    OPTIMIZE_ATK = 1003
    OPTIMIZE_DEF = 1004
    OPTIMIZE_SPI = 1005
    OPTIMIZE_AGI = 1006
    OPTIMIZE_EVA = 1007
    OPTIMIZE_HIT = 1008
    OPTIMIZE_CRI = 1009
    
    # Optimize modes definitions
    
    # Default Full Optimize mode
    FULL_OPTIMIZE_MODE = [OPTIMIZE_HP, OPTIMIZE_MP, OPTIMIZE_ATK, OPTIMIZE_DEF,
                      OPTIMIZE_SPI, OPTIMIZE_AGI, OPTIMIZE_EVA, OPTIMIZE_HIT,
                      OPTIMIZE_CRI]
    
    # Optimize modes array
    OPTIMIZE_MODES = [
      # First mode - Warrior style
      Optimize_Mode.new(0, 
                        [OPTIMIZE_HP, OPTIMIZE_ATK, OPTIMIZE_HIT, OPTIMIZE_CRI]),
      # Second mode - Defender style
      Optimize_Mode.new(1, 
                        [OPTIMIZE_HP, OPTIMIZE_DEF]), 
      # Third mode - Magi style
      Optimize_Mode.new(2, 
                        [OPTIMIZE_MP, OPTIMIZE_SPI]), 
      # Fourth mode - Agile style
      Optimize_Mode.new(3, 
                        [OPTIMIZE_AGI, OPTIMIZE_EVA]), 
      # Fifth mode - All Around style
      Optimize_Mode.new(4, 
                        [OPTIMIZE_HP, OPTIMIZE_MP, OPTIMIZE_ATK, OPTIMIZE_DEF,
                         OPTIMIZE_SPI, OPTIMIZE_AGI])
    ]
    
    #------------------------------------------------------------------------
    # Equip Status Window related
    #------------------------------------------------------------------------
    
    # Separator between the current stat and the new stat when comparing equipment
    EQUIP_STATUS_SEPARATOR = ">>>"
    
    #------------------------------------------------------------------------
    # Element Resistance Graph related
    #------------------------------------------------------------------------
    
    # Minimum value used in the Elemental Resistance Graph 
    ELEM_RES_MIN = -100
    # Maximum value used in the Elemental Resistance Graph 
    ELEM_RES_MAX = 200
    
    #------------------------------------------------------------------------
    # Status Resistance Graph related
    #------------------------------------------------------------------------
    
    # Minimum value used in the Status Resistance Graph 
    STATES_RES_MIN = -100
    # Maximum value used in the Status Resistance Graph 
    STATES_RES_MAX = 100
    
    #------------------------------------------------------------------------
    # Scene Status related
    #------------------------------------------------------------------------
    
    # BODY IMAGES by actor id
    # (Put your images inside the Graphics/Pictures folder.)
    BODY_IMAGES = []
    BODY_IMAGES[1] = Actor_Body_Image.new("face001.png", Rect.new(98,0,102,288))
    BODY_IMAGES[2] = Actor_Body_Image.new("face004.png", Rect.new(75,0,102,288))
    BODY_IMAGES[3] = Actor_Body_Image.new("face010.png", Rect.new(95,0,102,268))
    BODY_IMAGES[4] = Actor_Body_Image.new("face015.png", Rect.new(85,0,102,288))
    
    #------------------------------------------------------------------------
    # System Window related
    #------------------------------------------------------------------------
    
    # Hash containing the different windowkins available
    # ( ID 0 will
    #  automatically push back to the default window's ID.)
    WINDOW_HASH ={
    # Window ID => [      Name, Filename, Opac, Back_Opac,  [Bold, Italic, Shadow, Size,    Font]],
              1 => [     "Red", "Red.png", 255, 200, Font.default_settings],
              2 => [  "Orange", "Orange.png", 255, 200, Font.default_settings],
              3 => [  "Yellow", "Yellow.png", 255, 200, Font.default_settings],
              4 => [   "Green", "Green.png", 255, 200, Font.default_settings],
              5 => [    "Cyan", "Cyan.png", 255, 200, Font.default_settings],
              6 => [    "Navy", "Navy.png", 255, 200, Font.default_settings],
              7 => [    "Blue", "Blue.png", 255, 200, Font.default_settings],
              8 => [  "Violet", "Violet.png", 255, 200, Font.default_settings],
              9 => [  "Purple", "Purple.png", 255, 200, Font.default_settings],
             10 => [    "Pink", "Pink.png", 255, 200, Font.default_settings],
             11 => [    "Grey", "Grey.png", 255, 200, Font.default_settings],
             12 => [   "Black", "Black.png", 255, 200, Font.default_settings],
             13 => [    "Blue", "Blue.png", 255, 255, [true,   true,    true,   20, ["UmePlus Gothic", "Verdana", "Arial", "Courier New"]]],
             14 => [   "Negative", "Negative.png", 255, 200, Font.default_settings],
             15 => [   "Invisible", "Blue.png", 0, 0, Font.default_settings],
             16 => [   "HalfBlue", "Blue.png", 125, 125, Font.default_settings],
    }
    
    # Pattern used to show the value of the volume
    VOL_PATTERN = "%d%%"
    
    #------------------------------------------------------------------------
    # Outline Window related
    #------------------------------------------------------------------------
    
    # Color ids used for specific names (item, skill, etc.)
    # (COLOR_ID is from Windowskin image in down-right corder)
    ITEM_NAME_COLOR_ID = 5 
    WEAPON_NAME_COLOR_ID = 10
    ARMOR_NAME_COLOR_ID = 4
    SKILL_NAME_COLOR_ID = 2
    
  end
end

#===============================================================================
# ** Game Map
#------------------------------------------------------------------------------
#  Function aliases for custom menu
#===============================================================================

class Game_Map
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize
    initialize_ebjb
    @map_infos = load_data("Data/MapInfos.rvdata")
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get map name
  #--------------------------------------------------------------------------
  # GET
  def name
    return @map_infos[@map_id].name
  end
  
end

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Get Now Exp - The experience gained for the current level.
  #--------------------------------------------------------------------------
  # GET
  def now_exp
    return @exp - @exp_list[@level]
  end
  
  #--------------------------------------------------------------------------
  # Get Next Exp - The experience needed for the next level.
  #--------------------------------------------------------------------------
  # GET
  def next_exp
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0
  end
  
end

#===============================================================================
# ** Game Party
#------------------------------------------------------------------------------
#  Function aliases for custom menu
#===============================================================================

class Game_Party
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array containing the newest gained items
  attr_reader   :newest_items
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize
    initialize_ebjb
    @newest_items = []
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias gain item
  #--------------------------------------------------------------------------
  alias gain_item_ebjb gain_item unless $@
  def gain_item(item, n, include_equip = false)
    # gain item
    if n > 0
      # don't update newest_items in Equip scene
      if !$scene.is_a?(Scene_Equip)      
        if @newest_items.length == MENU_CONFIG::MAX_NEWEST_ITEMS
          @newest_items.pop()
        end
        @newest_items.insert(0,item)
      end
    # lose item
    else
      if @newest_items.include?(item)
        @newest_items.delete(item)
      end
    end
    gain_item_ebjb(item, n, include_equip)
  end
  
end

#==============================================================================
# ** Game_Temp
#------------------------------------------------------------------------------
#  This class handles temporary data that is not included with save data.
# The instance of this class is referenced by $game_temp.
#==============================================================================

class Game_Temp
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Original background bitmap
  attr_accessor :orig_background_bitmap
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_ebjb initialize unless $@
  def initialize
    initialize_ebjb()
    @orig_background_bitmap = Bitmap.new(1, 1)
  end
  
end

#==============================================================================
# ** Scene_Menu
#------------------------------------------------------------------------------
#  This class performs the menu screen processing.
#==============================================================================

class Scene_Menu < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     menu_index : command cursor's initial position
  #--------------------------------------------------------------------------
  def initialize(menu_index = 0)
    @menu_index = menu_index
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
    
    create_command_window()
    @status_window = Window_Party_Status.new(0, 0, 480,424, $game_party.members)
    @menu_info_window = Window_Menu_Info.new(0,424,640,56)
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
    @command_window.dispose if @command_window != nil
    @status_window.dispose if @status_window != nil
    @menu_info_window.dispose if @menu_info_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background()
    
    @command_window.update
    @status_window.update
    @menu_info_window.update
    if @command_window.active
      update_command_selection
    elsif @status_window.active
      update_actor_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Create Command Window
  #--------------------------------------------------------------------------
  def create_command_window
    s1 = Vocab::item
    s2 = Vocab::skill
    s3 = Vocab::equip
    s4 = Vocab::status
    s5 = Vocab::save
    s6 = Vocab::load
    s7 = Vocab::game_end
    @command_window = Window_Command.new(160, [s1, s2, s3, s4, s5, s6, s7])
    @command_window.index = @menu_index
    @command_window.x = 480
    if $game_party.members.size == 0          # If number of party members is 0
      @command_window.draw_item(0, false)     # Disable item
      @command_window.draw_item(1, false)     # Disable skill
      @command_window.draw_item(2, false)     # Disable equipment
      @command_window.draw_item(3, false)     # Disable status
    end
    if $game_system.save_disabled             # If save is forbidden
      @command_window.draw_item(4, false)     # Disable save
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Command Selection
  #--------------------------------------------------------------------------
  def update_command_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      $scene = Scene_Map.new
    elsif Input.trigger?(Input::C)
      if $game_party.members.size == 0 and @command_window.index < 4
        Sound.play_buzzer
        return
      elsif $game_system.save_disabled and @command_window.index == 4
        Sound.play_buzzer
        return
      end
      Sound.play_decision
      case @command_window.index
      when 0      # Item
        $scene = Scene_Item.new
      when 1,2,3  # Skill, equipment, status
        start_actor_selection
      when 4      # Save
        $scene = Scene_File.new(true, false, false, 4)
      when 5      # Save
        $scene = Scene_File.new(false, false, false, 5)
      when 6      # End Game
        $scene = Scene_End.new
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Start Actor Selection
  #--------------------------------------------------------------------------
  def start_actor_selection
    @command_window.active = false
    @status_window.active = true
    if $game_party.last_actor_index < @status_window.item_max
      @status_window.index = $game_party.last_actor_index
    else
      @status_window.index = 0
    end
  end
  
  #--------------------------------------------------------------------------
  # * End Actor Selection
  #--------------------------------------------------------------------------
  def end_actor_selection
    @command_window.active = true
    @status_window.active = false
    @status_window.index = -1
  end
  
  #--------------------------------------------------------------------------
  # * Update Actor Selection
  #--------------------------------------------------------------------------
  def update_actor_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_actor_selection
    elsif Input.trigger?(Input::C)
      $game_party.last_actor_index = @status_window.index
      Sound.play_decision
      case @command_window.index
      when 1  # skill
        $scene = Scene_Skill.new(@status_window.index)
      when 2  # equipment
        $scene = Scene_Equip.new(@status_window.index)
      when 3  # status
        $scene = Scene_Status.new(@status_window.index)
      end
    end
  end
  
end

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

#==============================================================================
# ** Scene_Item
#------------------------------------------------------------------------------
#  This class performs the item screen processing.
#==============================================================================

class Scene_Item < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start processing
  #--------------------------------------------------------------------------
  def start
    super
    create_menu_background
    if MENU_CONFIG::IMAGE_BG != ""
      @bg = Sprite.new
      @bg.bitmap = Cache.picture(MENU_CONFIG::IMAGE_BG)
      @bg.opacity = MENU_CONFIG::IMAGE_BG_OPACITY
    end
    
    @help_window = Window_Info_Help.new(0, 384, 640, 96, nil)
    
    @item_back_window = Window_Base.new(0, 56, 640, 328)
    @dataviews_window = Window_Dataviews.new(0, 56, 640, 56, MENU_CONFIG::ITEM_DATAVIEWS)
    @dataviews_window.active = false
    @dataviews_window.opacity = 0
    
    @item_window = Window_Item.new(0, 96, 640, 272, $game_party.items, @dataviews_window.selected_view)
    @item_window.opacity = 0
    @item_window.help_window = @help_window
    
    @equip_details_window = Window_EquipDetails.new(0,384,640,96,nil)
    @equip_details_window.visible = false
    @item_details_window = Window_ItemDetails.new(0,384,640,96,nil)
    @item_details_window.visible = false
    update_detail_window(@item_window.selected_item)
    
    @target_window = Window_Party_Status.new(0, 0, 480, 424, $game_party.members)
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
    @help_window.dispose if @help_window != nil
    @dataviews_window.dispose if @dataviews_window != nil
    @equip_details_window.dispose if @equip_details_window != nil
    @item_details_window.dispose if @item_details_window != nil
    @item_back_window.dispose if @item_back_window != nil
    @item_window.dispose if @item_window != nil
    @target_window.dispose if @target_window != nil
  end
  
  #--------------------------------------------------------------------------
  # * Update Frame
  #--------------------------------------------------------------------------
  def update
    super
    update_menu_background
    @help_window.update
    @item_window.update
    @dataviews_window.update
    @item_back_window.update
    @equip_details_window.update
    @item_details_window.update
    @target_window.update
    if @item_window.active
      update_item_selection
    elsif @target_window.active
      update_target_selection
    end
  end
  
  #--------------------------------------------------------------------------
  # * Confirm Item
  #--------------------------------------------------------------------------
  def determine_item
    if @item.for_friend?
      show_target_window(@item_window.index % 2 == 0)
      if @item.for_all?
        @target_window.index = 0
        @target_window.cursor_select_all()
      else
        if $game_party.last_target_index < @target_window.item_max
          @target_window.index = $game_party.last_target_index
        else
          @target_window.index = 0
        end
      end
    else
      use_item_nontarget
    end
  end
  
  #--------------------------------------------------------------------------
  # * Show Target Window
  #     right : Right justification flag (if false, left justification)
  #--------------------------------------------------------------------------
  def show_target_window(right)
    @item_window.active = false
    width_remain = (640 - @target_window.width)/2
    @target_window.x = width_remain.floor
    heigth_remain = (480 - @target_window.height)/2
    @target_window.y = heigth_remain.floor
    @target_window.visible = true
    @target_window.active = true
  end
  
  #--------------------------------------------------------------------------
  # * Hide Target Window
  #--------------------------------------------------------------------------
  def hide_target_window
    @item_window.active = true
    @target_window.visible = false
    @target_window.active = false
  end

  #--------------------------------------------------------------------------
  # * Use Item (apply effects to non-ally targets)
  #--------------------------------------------------------------------------
  def use_item_nontarget
    Sound.play_use_item
    $game_party.consume_item(@item)
    @item_window.draw_item(@item_window.index)
    @target_window.window_update($game_party.members)
    if $game_party.all_dead?
      $scene = Scene_Gameover.new
    elsif @item.common_event_id > 0
      $game_temp.common_event_id = @item.common_event_id
      $scene = Scene_Map.new
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
      @item_window.detail_window = @item_details_window
    else
      @item_window.detail_window = @equip_details_window
    end
  end
  private :update_detail_window
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_item_selection
    if Input.trigger?(Input::B)
      Sound.play_cancel
      return_scene
    elsif Input.trigger?(Input::C)
      @item = @item_window.item
      if @item != nil
        $game_party.last_item_id = @item.id
      end
      if $game_party.item_can_use?(@item)
        Sound.play_decision
        determine_item
      else
        Sound.play_buzzer
      end
    elsif Input.repeat?(Input::DOWN) || Input.repeat?(Input::UP) ||
          Input.repeat?(Input::LEFT) || Input.repeat?(Input::RIGHT)
      update_detail_window(@item_window.selected_item)
    elsif (Input.repeat?(Input::Y) || Input.repeat?(Input::Z))
      update_dataview_select(Input.press?(Input::Z), 
                             Input.trigger?(Input::Y) || Input.trigger?(Input::Z))
      @item_window.window_update($game_party.items, @dataviews_window.selected_view)
      @item_window.index = 0
      update_detail_window(@item_window.selected_item)
    end
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update dataview selection
  #     isRight : true to move right, else false to move left
  #     wrap : Wraparound allowed
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

#==============================================================================
# ** Scene_Battle
#------------------------------------------------------------------------------
#   This class performs battle screen processing.
#==============================================================================

class Scene_Battle < Scene_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Start Item Selection
  #--------------------------------------------------------------------------
  def start_item_selection
    @actor_command_window.active = false
    
    @help_window = Window_Help.new()
    #@help_window = Window_Info_Help.new(0, 384, nil)   
    #@help_window = Window_Info_Help.new(0, 0, nil)
    #@help_window.width = 544
    
    #@item_back_window = Window_Base.new(0, 56, 640, 328)
    #@dataviews_window = Window_Dataviews.new(0, 56, MENU_CONFIG::DATAVIEWS)
    #@dataviews_window.active = false
    #@dataviews_window.opacity = 0
    
    #@item_window = Window_Item.new(0, 96, 640, 272, @dataviews_window.apply_dataview($game_party.items))
    @item_window = Window_Item.new(0, 56, 544, 232, $game_party.items)
    #@item_window.opacity = 0
    @item_window.help_window = @help_window
    
    #@item_details_window = Window_ItemDetails.new(0,384,nil)
    #@item_details_window = Window_ItemDetails.new(0,0,nil)
    #@item_details_window.visible = false
    #@item_window.detail_window = @item_details_window
  end
  
  #--------------------------------------------------------------------------
  # * End Item Selection
  #--------------------------------------------------------------------------
  def end_item_selection
    @help_window.dispose if @help_window != nil
    @help_window = nil
    #@item_back_window.dispose if @item_back_window != nil
    #@item_back_window = nil
    #@dataviews_window.dispose if @dataviews_window != nil
    #@dataviews_window = nil
    @item_window.dispose if @item_window != nil
    @item_window = nil
    #@item_details_window.dispose if @item_details_window != nil
    #@item_details_window = nil
    
    @actor_command_window.active = true
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Scene input management methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update Item Selection
  #--------------------------------------------------------------------------
  def update_item_selection
    @item_window.active = true
    @item_window.update
    @help_window.update
    #@item_back_window.update
    #@dataviews_window.update
    #@item_details_window.update
    
    if Input.trigger?(Input::B)
      Sound.play_cancel
      end_item_selection
    elsif Input.trigger?(Input::C)
      @item = @item_window.item
      if @item != nil
        $game_party.last_item_id = @item.id
      end
      if $game_party.item_can_use?(@item)
        Sound.play_decision
        determine_item
      else
        Sound.play_buzzer
      end
    #elsif (Input.repeat?(Input::Y) || Input.repeat?(Input::Z))
    #  update_dataview_select(Input.press?(Input::Z), 
    #                         Input.trigger?(Input::Y) || Input.trigger?(Input::Z))
    #  @item_window.window_update(@dataviews_window.apply_dataview($game_party.items))
    #  @item_window.index = 0
    end
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update dataview selection
  #     isRight : true to move right, else false to move left
  #-------------------------------------------------------------------------- 
  #def update_dataview_select(isRight, wrap)
  #  if isRight
  #    @dataviews_window.cursor_right(wrap)
  #  else      
  #    @dataviews_window.cursor_left(wrap)
  #  end
  #end
  #private :update_dataview_select
  
end
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

#==============================================================================
# ** Scene_Title
#------------------------------------------------------------------------------
#  This class performs the title screen processing.
#==============================================================================

class Scene_Title < Scene_Base
  include Wora_NSS
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine if Continue is Enabled
  #--------------------------------------------------------------------------
  def check_continue
    filename = SAVE_PATH + SAVE_FILE_NAME.gsub(/\{ID\}/i) { '*' }
    @continue_enabled = (Dir.glob(filename).size > 0)
  end
  
end

#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map < Scene_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create Snapshot for Using as Background of Another Screen
  #--------------------------------------------------------------------------
  def snapshot_for_background
    $game_temp.orig_background_bitmap.dispose
    $game_temp.background_bitmap.dispose
    $game_temp.orig_background_bitmap = Graphics.snap_to_bitmap
    $game_temp.background_bitmap = $game_temp.orig_background_bitmap.clone
    $game_temp.background_bitmap.blur
  end
  
end

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

#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  Contains the different fonts
#==============================================================================

class Font
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Graph Label Font
  #--------------------------------------------------------------------------
  def self.graph_label_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Party Status Font
  #--------------------------------------------------------------------------
  def self.party_stat_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Save Location Font
  #--------------------------------------------------------------------------
  def self.save_location_font
    f = Font.new()
    f.size = 48
    f.bold = true
    f.italic = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Optimize Mode Font
  #--------------------------------------------------------------------------
  def self.optimize_mode_font
    f = Font.new()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Optimize Mode Header Font
  #--------------------------------------------------------------------------
  def self.optimize_mode_header_font
    f = Font.new()
    f.color = Color.system_color
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Stats Font
  #--------------------------------------------------------------------------
  def self.item_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Plus States Font
  #--------------------------------------------------------------------------
  def self.item_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Minus States Font
  #--------------------------------------------------------------------------
  def self.item_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details HP/MP Font
  #--------------------------------------------------------------------------
  def self.skill_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Plus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Minus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
end

#==============================================================================
# ** Color
#------------------------------------------------------------------------------
#  Contains the different colors
#==============================================================================

class Color
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.hp_gauge_color1
    return text_color(20)
  end
  
  #--------------------------------------------------------------------------
  # * Get HP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.hp_gauge_color2
    return text_color(21)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 1
  #--------------------------------------------------------------------------
  def self.mp_gauge_color1
    return text_color(22)
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Gauge Color 2
  #--------------------------------------------------------------------------
  def self.mp_gauge_color2
    return text_color(23)
  end
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 1
  #--------------------------------------------------------------------------
  def self.exp_gauge_color1
    return text_color(14)
  end
  
  #--------------------------------------------------------------------------
  # * Get Exp Gauge Color 2
  #--------------------------------------------------------------------------
  def self.exp_gauge_color2
    return text_color(17)
  end
  
  #--------------------------------------------------------------------------
  # * Get Image Border Color
  #--------------------------------------------------------------------------
  def self.image_border_color
    return text_color(19)
  end
  
  #--------------------------------------------------------------------------
  # * Get Positive Resist Gauge Color 1
  #--------------------------------------------------------------------------
  def self.pos_resist_gauge_color1
    return text_color(22)
  end
  
  #--------------------------------------------------------------------------
  # * Get Positive Resist Gauge Color 2
  #--------------------------------------------------------------------------
  def self.pos_resist_gauge_color2
    return text_color(23)
  end
  
  #--------------------------------------------------------------------------
  # * Get Negative Resist Gauge Color 1
  #--------------------------------------------------------------------------
  def self.neg_resist_gauge_color1
    return text_color(20)
  end
  
  #--------------------------------------------------------------------------
  # * Get Negative Resist Gauge Color 2
  #--------------------------------------------------------------------------
  def self.neg_resist_gauge_color2
    return text_color(21)
  end
  
  #--------------------------------------------------------------------------
  # * Get Resist Border Color 1
  #--------------------------------------------------------------------------
  def self.resist_border_color1
    return text_color(0)
  end
  
  #--------------------------------------------------------------------------
  # * Get Resist Border Color 2
  #--------------------------------------------------------------------------
  def self.resist_border_color2
    return text_color(7)
  end
  
  #--------------------------------------------------------------------------
  # * Get New item Color
  #--------------------------------------------------------------------------
  def self.new_item_color
    return text_color(3)
  end
  
  #--------------------------------------------------------------------------
  # * Get Volume Bar Border Color
  #--------------------------------------------------------------------------
  def self.volume_border_color
    return text_color(19)
  end

end

#==============================================================================
# ** Vocab
#------------------------------------------------------------------------------
#  This module defines terms and messages. It defines some data as constant
# variables. Terms in the database are obtained from $data_system.
#==============================================================================

module Vocab

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #//////////////////////////////////////////////////////////////////////////
  # * Stats Parameters related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get HP Label
  #--------------------------------------------------------------------------
  def self.hp_label
    return self.hp
  end
  
  #--------------------------------------------------------------------------
  # * Get MP Label
  #--------------------------------------------------------------------------
  def self.mp_label
    return self.mp
  end
  
  #--------------------------------------------------------------------------
  # * Get ATK Label
  #--------------------------------------------------------------------------
  def self.atk_label
    return self.atk
  end
  
  #--------------------------------------------------------------------------
  # * Get DEF Label
  #--------------------------------------------------------------------------
  def self.def_label
    return self.def
  end
  
  #--------------------------------------------------------------------------
  # * Get SPI Label
  #--------------------------------------------------------------------------
  def self.spi_label
    return self.spi
  end
  
  #--------------------------------------------------------------------------
  # * Get AGI Label
  #--------------------------------------------------------------------------
  def self.agi_label
    return self.agi
  end
  
  #--------------------------------------------------------------------------
  # * Get EVA Label
  #--------------------------------------------------------------------------
  def self.eva_label
    return "EVA"
  end
  
  #--------------------------------------------------------------------------
  # * Get HIT Label
  #--------------------------------------------------------------------------
  def self.hit_label
    return "HIT"
  end
  
  #--------------------------------------------------------------------------
  # * Get CRI Label
  #--------------------------------------------------------------------------
  def self.cri_label
    return "CRI"
  end
  
  #--------------------------------------------------------------------------
  # * Get EXP Label
  #--------------------------------------------------------------------------
  def self.exp_label
    return "EXP"
  end
  
  #--------------------------------------------------------------------------
  # * Get Level Label
  #--------------------------------------------------------------------------
  def self.lvl_label
    return self.level
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Menu related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Load Label
  #--------------------------------------------------------------------------
  def self.load
    return "Load"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Details Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Elements list
  #--------------------------------------------------------------------------
  def self.elements_label
    return "ELEMENTS"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the States list
  #--------------------------------------------------------------------------
  def self.states_label
    return "STATES"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Stats
  #--------------------------------------------------------------------------
  def self.stats_label
    return "STATS"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Recovery effect
  #--------------------------------------------------------------------------
  def self.recovery_label
    return "RECOVERY"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Damage effect
  #--------------------------------------------------------------------------
  def self.damage_label
    return "DAMAGE"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Scope list
  #--------------------------------------------------------------------------
  def self.scopes_label
    return "DAMAGE"
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Bonus list
  #--------------------------------------------------------------------------
  def self.bonus_label
    return "BONUS"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Menu Info Window related
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get Label to show for the current location
  #--------------------------------------------------------------------------
  def self.location_label
    return "Location"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Save Details Window related
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get Label to show for the saved location
  #--------------------------------------------------------------------------
  def self.save_location_label
    return "Location"
  end
    
  #//////////////////////////////////////////////////////////////////////////
  # Confirmation Window related
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Get Text to confirm to save file
  #--------------------------------------------------------------------------
  def self.confirm_save_text
    return "Confirm to save ?"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show Yes command of the confirmation window
  #--------------------------------------------------------------------------
  def self.confirm_yes_text
    return "Yes"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show No command of the confirmation window
  #--------------------------------------------------------------------------
  def self.confirm_no_text
    return "No"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Window Char Info related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show Total Exp.
  #--------------------------------------------------------------------------
  def self.char_info_total_exp_label
    return "TOTAL"
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Window Status related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the active states list
  #--------------------------------------------------------------------------
  def self.active_status_label
    return "Active status"
  end

  #--------------------------------------------------------------------------
  # * Get Label for Elemental Resistance
  #--------------------------------------------------------------------------
  def self.elem_resist_label
    return "Elemental Resist."
  end
  
  #--------------------------------------------------------------------------
  # * Get Label for States Resistance
  #--------------------------------------------------------------------------
  def self.states_resist_label
    return "States Resist."
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # System Window related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Window Skin setting
  #--------------------------------------------------------------------------
  def self.system_window_skin_label
    return YE::SYSTEM::WINDOW_SKIN
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Window Skin setting
  #--------------------------------------------------------------------------
  def self.system_window_skin_help_text
    return YE::SYSTEM::WINDOW_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the BGM volume setting
  #--------------------------------------------------------------------------
  def self.system_bgm_label
    return YE::SYSTEM::BGM_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the BGM volume setting
  #--------------------------------------------------------------------------
  def self.system_bgm_help_text
    return YE::SYSTEM::BGM_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the SFX volume setting
  #--------------------------------------------------------------------------
  def self.system_sfx_label
    return YE::SYSTEM::SFX_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the SFX volume setting
  #--------------------------------------------------------------------------
  def self.system_sfx_help_text
    return YE::SYSTEM::SFX_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the BGS volume setting
  #--------------------------------------------------------------------------
  def self.system_bgs_label
    return YE::SYSTEM::BGS_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the BGS volume setting
  #--------------------------------------------------------------------------
  def self.system_bgs_help_text
    return YE::SYSTEM::BGS_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show when muting volume
  #--------------------------------------------------------------------------
  def self.system_mute_volume_label
    return YE::SYSTEM::VOL_MUTE
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Battle Animations setting
  #--------------------------------------------------------------------------
  def self.system_ani_label
    return YE::SYSTEM::ANI_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Battle Animations setting
  #--------------------------------------------------------------------------
  def self.system_ani_help_text
    return YE::SYSTEM::ANI_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Battle Animations setting is ON
  #--------------------------------------------------------------------------
  def self.system_ani_on_command
    return YE::SYSTEM::ANI_ON
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Battle Animations setting is OFF
  #--------------------------------------------------------------------------
  def self.system_ani_off_command
    return YE::SYSTEM::ANI_OFF
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Automatic Dashing setting
  #--------------------------------------------------------------------------
  def self.system_autodash_label
    return YE::SYSTEM::AUTO_DASH_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Automatic Dashing setting
  #--------------------------------------------------------------------------
  def self.system_autodash_help_text
    return YE::SYSTEM::AUTO_DASH_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Automatic Dashing setting is ON
  #--------------------------------------------------------------------------
  def self.system_autodash_on_command
    return YE::SYSTEM::AUTO_DASH_ON
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Automatic Dashing setting is OFF
  #--------------------------------------------------------------------------
  def self.system_autodash_off_command
    return YE::SYSTEM::AUTO_DASH_OFF
  end 
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Instant Text setting
  #--------------------------------------------------------------------------
  def self.system_instanttext_label
    return YE::SYSTEM::INSTANT_TEXT_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Instant Text setting
  #--------------------------------------------------------------------------
  def self.system_instanttext_help_text
    return YE::SYSTEM::INSTANT_TEXT_HELP
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Instant Text setting is ON
  #--------------------------------------------------------------------------
  def self.system_instanttext_on_command
    return YE::SYSTEM::INSTANT_TEXT_ON
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show when Instant Text setting is OFF
  #--------------------------------------------------------------------------
  def self.system_instanttext_off_command
    return YE::SYSTEM::INSTANT_TEXT_OFF
  end 
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Difficulty setting
  #--------------------------------------------------------------------------
  def self.system_difficulty_label
    return "Difficulty"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Difficulty setting
  #--------------------------------------------------------------------------
  def self.system_difficulty_help_text
    return "Sets the difficulty of the game."
  end
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every difficulty setting (name)
  #--------------------------------------------------------------------------
  def self.difficulty_strings
    return [
     KGC::BattleDifficulty::DIFFICULTY[0][:name],
     KGC::BattleDifficulty::DIFFICULTY[1][:name],
     KGC::BattleDifficulty::DIFFICULTY[2][:name],
     KGC::BattleDifficulty::DIFFICULTY[3][:name],
     KGC::BattleDifficulty::DIFFICULTY[4][:name],
     KGC::BattleDifficulty::DIFFICULTY[5][:name]
    ]
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the In-Game tutorials
  #--------------------------------------------------------------------------
  def self.system_tutorials_label
    return "In-Game Tutorials"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the In-Game tutorials
  #--------------------------------------------------------------------------
  def self.system_tutorials_help_text
    return "Shows different tutorials."
  end
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every in-game tutorial (name + [text, ...])
  #--------------------------------------------------------------------------
  def self.tutorials_strings
    return [
      ["Outline Features",  # No.0
        ["Here, I'll explain how to use the outline features:",
        "",
        "You can change font name, like this:",
        "\\fn[Microsoft Sans Serif]Sans Serif Font\\ref",
        "You can change font size, like this:",
        "\\fs[20]Font \\fs[25]Size \\fs[30]Thirty\\fs[25]!!\\fs[20]!!\\res",
        "You can change font color, like this:",
        "\\c[10]Test color\\c[0]",
        "",
        "You can turn on/off bold text, like this:",
        "\\bBold Text Here!\\b",
        "You can turn on/off italic text, like this:",
        "\\iItalic Text Here!\\i",
        "You can turn on/off text shadow, like this:",
        "\\shShadow Text Here!\\sh",
        "",
        "You can draw icons, like this:",
        "\\ic[1] and \\ic[30]",
        "You can draw image from folder 'Picture', like this:",
        "\\dp[worldmap.png]",
        "With a border, like this:",
        "\\dp[bigimage.png,border{2,0}]",
        "With a specific size, like this:",
        "\\dp[bigimage.png,size{100,200}]",
        "With a border and a specific size, like this:",
        "\\dp[bigimage.png,size{100,200},border{2,0}]",
        "",
        "You can show variable value, like this:",
        "\\v[1]",
        "You can show some actor's info, like this:",
        "Name: \\n[1]",
        "Class: \\nc[1]",
        "Face: \\fa[1]",
        "You can show some party's info, like this:",
        "Second party member: \\np[2]",
        "You can show monster's name, like this:",
        "\\nm[1]",
        "You can show troop's name, like this:",
        "\\nt[1]",
        "You can show draw some information about items, like this:",
        "Weapon name: \\nw[1]",
        "Weapon icon + name + color: \\dw[1]",
        "Armor name: \\na[1]",
        "Armor icon + name + color: \\da[1]",
        "Skill name: \\ns[1]",
        "Skill icon + name + color: \\ds[1]",
        "Item name: \\ni[1]",
        "Item icon + name + color: \\di[1]",
        "Item price: \\price[1]",
        "",
        "The text is automatically cut to new line when the window's width " +
        "is not enough for text. This will be really useful when you " +
        "change window's size or font.",
        "",
        "You can also merge every of these features like this: \\dw[1] " +
        "or this: \\da[1] or this: \\ds[1] or this: \\di[1] or this: " +
        "\\dp[worldmap.png] and the \\c[10]multiline\\c[0] still " +
        "\\bworks !!\\b \\fs[30]Nice\\res \\iisn't it\\i ?",]],
      ["Outline Title", # No.1
        ["Add description here...",]],
    ]  # -- Don't delete this line! --
  end
  
  #--------------------------------------------------------------------------
  # * Get Label to show for the Return to Title Screen option
  #--------------------------------------------------------------------------
  def self.system_totitle_label
    return YE::SYSTEM::RETURN_TO_TITLE
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show to describe the Return to Title Screen option
  #--------------------------------------------------------------------------
  def self.system_totitle_help_text
    return YE::SYSTEM::RETURN_TITLE_HELP
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Equip related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Equip command
  #--------------------------------------------------------------------------
  def self.equip_command
    return "Equip"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Optimize command
  #--------------------------------------------------------------------------
  def self.equip_optimize_command
    return "Optimize"
  end
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Remove command
  #--------------------------------------------------------------------------
  def self.equip_remove_command
    return "Remove"
  end 
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Remove All command
  #--------------------------------------------------------------------------
  def self.equip_remove_all_command
    return "Remove All"
  end 
  
  #--------------------------------------------------------------------------
  # * Get Text to show for Optimize mode
  #--------------------------------------------------------------------------
  def self.optimize_mode_text
    return "Optimize Style"
  end
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every optimize mode (name + description)
  #--------------------------------------------------------------------------
  def self.optimize_modes_strings
    return [
     ["Warrior", "This style is focusing on pure strength."],
     ["Defender", "This style is focusing on defense."],
     ["Magi", "This style is focusing on magic power."],
     ["Agile", "This style is focusing on speed, evade and agility."],
     ["All Around", "This style is for the all around guy."]
    ]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # Scene Item related
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Strings to show for every dataview (name)
  #--------------------------------------------------------------------------
  def self.dataviews_strings
    return [
     "New",
     "Type",
     "A-Z",
     "Z-A",
     self.mp_label
    ]
  end
  
end

#==============================================================================
# ** Window_Party_Status
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_Party_Status < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCPartyCharStatus for every character in the party
  attr_reader :ucPartyCharStatusList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     characters : characters list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, characters)
    super(x, y, width, height, 8, height - 32)
    @column_max = 4
    @ucPartyCharStatusList = []
    window_update(characters)
    self.index = -1
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucPartyCharStatusList.each() { |partyCharData| partyCharData.draw() }
  end

  #--------------------------------------------------------------------------
  # * Update
  #     characters : characters list
  #--------------------------------------------------------------------------
  def window_update(characters)
    @data = []
    if characters != nil
      for char in characters
        if char != nil
          @data.push(char)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucPartyCharStatusList.clear()
      for i in 0..@item_max-1
        @ucPartyCharStatusList.push(create_item(i))
      end
    end
    refresh()
  end  
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    for charStatus in @ucPartyCharStatusList
      charStatus.ucActStates.update()
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for PartyCharStatusList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    actor = @data[index]
    rect = item_rect(index, true, true)
    
    charStatus = UCPartyCharStatus.new(self, actor, rect)
    
    return charStatus
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Menu_Info
#------------------------------------------------------------------------------
#  This window shows generic information about the party
#==============================================================================

class Window_Menu_Info < Window_Base
  include EBJB
   
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelValue for the location (or map) name
  attr_reader :ucLocation
  # UCLabelIcon for the current time
  attr_reader :ucTime
  # UCLabelIcon for the party's gold
  attr_reader :ucGold
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     text : text to display
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height)
    super(x, y, width, height)
    
    @ucLocation = UCLabelValue.new(self, Rect.new(248,0,80,WLH), Rect.new(332,0,308,WLH),
                                   Vocab::location_label, "")
    @ucLocation.cLabel.font = Font.bold_font
    
    @ucTime = UCLabelIcon.new(self, Rect.new(24,0,80,WLH), Rect.new(0,0,24,24), "", 188)
    @ucTime.cLabel.align = 2
    @ucGold = UCLabelIcon.new(self, Rect.new(148,0,80,WLH), Rect.new(124,0,24,24), "", 147)
    @ucGold.cLabel.align = 2
    
    window_update()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update()
    if $game_party != nil
      @ucLocation.cValue.text = $game_map.name
      
      @total_sec = Graphics.frame_count / Graphics.frame_rate
      hour = @total_sec / 60 / 60
      min = @total_sec / 60 % 60
      sec = @total_sec % 60
    
      @ucTime.cLabel.text = sprintf(MENU_CONFIG::TIME_PATTERN, hour, min, sec)
      @ucGold.cLabel.text = $game_party.gold
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    if Graphics.frame_count / Graphics.frame_rate != @total_sec
      window_update()
    end
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucLocation.draw()
    @ucTime.draw()
    @ucGold.draw()
  end
  
end
#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Control that shows the character status
  attr_reader :ucCharStatus
  # Label for the Elemental Resistance graph
  attr_reader :cElementalResistLabel
  # Elemental Resistance graph
  attr_reader :ucElementalResistGraph
  # Label for the States Resistance graph
  attr_reader :cStatesResistLabel
  # States Resistance graph
  attr_reader :ucStatesResistGraph
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
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
    
    @ucCharStatus = UCCharStatus.new(self, actor, Rect.new(0,0,190,240))
    
    @cElementalResistLabel = CLabel.new(self, Rect.new(0,260,185,WLH), Vocab::elem_resist_label)

    @ucElementalResistGraph = UCGraph.new(self, 100, 345, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                          MENU_CONFIG::ELEM_RES_MAX,
                                          MENU_CONFIG::ELEM_RES_MIN,
                                          Font.graph_label_font,
                                          Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                          Color.neg_resist_gauge_color1, Color.neg_resist_gauge_color2, 
                                          nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                               
    @cStatesResistLabel = CLabel.new(self, Rect.new(205,260,185,WLH), Vocab::states_resist_label)
    
    @ucStatesResistGraph = UCGraph.new(self, 310, 345, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                       MENU_CONFIG::STATES_RES_MAX,
                                       MENU_CONFIG::STATES_RES_MIN,
                                       Font.graph_label_font,
                                       Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                       nil, nil,
                                       nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                                     
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    @ucCharStatus.ucActStates.update()
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil                              
      #------------------------------------------
      # Resistances section
      #------------------------------------------
      elements = []
      for i in 9..16
        elements.push(GraphElement.new(CORE_CONFIG::ELEMENT_ICONS[i], actor.element_rate(i)))
      end
      @ucElementalResistGraph.elements = elements

      elements = []
      for i in 1 .. $data_states.size-1
        state = $data_states[i]
        if !state.nonresistance         
          elements.push(GraphElement.new(state.icon_index, actor.state_probability(state.id)))
        end
      end
      @ucStatesResistGraph.elements = elements
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCharStatus.draw()
    @cElementalResistLabel.draw()
    @ucElementalResistGraph.draw()
    @cStatesResistLabel.draw()
    @ucStatesResistGraph.draw()
  end
  
end

#===============================================================================
# ** Window_Char_Image
#------------------------------------------------------------------------------
#  This window displays the actor background image
#===============================================================================

class Window_Char_Image < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # CResizableImage to show the character image
  attr_reader :cBackCharImage
  
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
    @cBackCharImage = CResizableImage.new(self, Rect.new(0, 0, self.contents.width, self.contents.height), 
                         nil, nil, 0, 255, 2, 3)
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
      bodyImg = MENU_CONFIG::BODY_IMAGES[actor.id]
      bitmap = Cache.picture(bodyImg.filename)
      @cBackCharImage.img_bitmap = bitmap
      @cBackCharImage.src_rect = Rect.new(bodyImg.src_rect.x, bodyImg.src_rect.y, 
                                          bitmap.width, bitmap.height)
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cBackCharImage.draw()
  end
  
end

#==============================================================================
# ** Window_Status_Equip
#------------------------------------------------------------------------------
#  This window displays the items the actor is currently equipped with
#==============================================================================

class Window_Status_Equip < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCEquipItem for every item the actor is equipped with
  attr_reader :ucEquipItemsList
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x     : window X coordinate
  #     y     : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    @ucEquipItemsList = []
    window_update(actor)
    self.index = 0
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
      @actor = actor
      equips = actor.equips
      @data = []
      if equips != nil
        for item in equips
          @data.push(item)
        end
        @item_max = @data.size
        create_contents()
        @ucEquipItemsList.clear()
        for i in 0..@item_max-1
          @ucEquipItemsList.push(create_item(i))
        end
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    self.contents.clear
    @ucEquipItemsList.each() { |equipItem| equipItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_item != nil
      @help_window.window_update(selected_item.description)
    else
      @help_window.window_update("")
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && 
           ((selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_ItemDetails)) ||
           (!selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #--------------------------------------------------------------------------
  # * Update cursor
  #--------------------------------------------------------------------------
  alias update_cursor_ebjb update_cursor unless $@ 
  def update_cursor
    update_cursor_ebjb
    if !self.cursor_rect.nil?
      # Change default cursor position
      rect = item_rect(@index*2+1)
      rect.y -= self.oy
      self.cursor_rect = rect
    end
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the EquipItems list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)

    case index
    when 0
      if @actor.two_swords_style
        kindDesc = Vocab::weapon1
      else
        kindDesc = Vocab::weapon
      end
    when 1
      if @actor.two_swords_style
        kindDesc = Vocab::weapon2
      else
        kindDesc = Vocab::armor1
      end
    when 2
      kindDesc = Vocab::armor2
    when 3
      kindDesc = Vocab::armor3
    when 4
      kindDesc = Vocab::armor4
    end
    
    rect.y += WLH*index 
    equipItem = UCEquipItem.new(self, item, rect, kindDesc)
     
    f = Font.new()
    f.color = system_color
    equipItem.cEquipKind.font = f
    return equipItem
  end
  private :create_item
  
end

#===============================================================================
# ** Window_Char_Info
#------------------------------------------------------------------------------
#  This window displays the actor name
#===============================================================================

class Window_Char_Info < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the character name
  attr_reader :cCharName
  # UCLabelIconValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's experience
  attr_reader :ucExp
  # UCBar for the EXP gauge of the character
  attr_reader :ucExpGauge
  # UCLabelIconValue for the character's total experience
  attr_reader :ucTotalExp
    
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
    
    @ucExp = UCLabelIconValue.new(self, Rect.new(24,48,25,WLH), 
                                     Rect.new(0,48,24,24), 
                                     Rect.new(25,48,135, WLH),
                                     Vocab::exp_label, 
                                     MENU_CONFIG::ICON_EXP, "")
    @ucExp.cValue.align = 2
    @ucExpGauge = UCBar.new(self, Rect.new(0,48+16,162,WLH-16), 
                              Color.exp_gauge_color1, Color.exp_gauge_color2, Color.gauge_back_color, 
                              0, 0, 1, Color.gauge_border_color)                    
    
    @ucTotalExp = UCLabelIconValue.new(self, Rect.new(24,72,50,WLH), 
                                     Rect.new(0,72,24,24), 
                                     Rect.new(50,72,112,WLH), 
                                     Vocab::char_info_total_exp_label, 
                                     MENU_CONFIG::ICON_TOTAL_EXP, "")
    @ucTotalExp.cValue.align = 2
    
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      @cCharName.text = actor.name
      @ucCharLvl.cValue.text = actor.level
      
      if (actor.next_exp == 0)
        gauge_min = 1
        gauge_max = 1
        exp_value = MENU_CONFIG::MAX_EXP_GAUGE_VALUE
      else
        gauge_min = actor.now_exp
        gauge_max = actor.next_exp
        exp_value = sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.now_exp, actor.next_exp)
      end
      
      @ucExp.cValue.text = exp_value
      @ucExpGauge.value = gauge_min
      @ucExpGauge.max_value = gauge_max
      
      @ucTotalExp.cValue.text = actor.exp
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
    @ucExpGauge.draw()
    @ucExp.draw()
    @ucTotalExp.draw()
  end
  
end

#==============================================================================
# ** Window_Item
#------------------------------------------------------------------------------
#  This window displays a list of inventory items for the item screen, etc.
#==============================================================================

class Window_Item < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCItem for every item in the inventory
  attr_reader :ucItemsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_item
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     items : items list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, items, dataview=nil)
    super(x, y, width, height)
    @column_max = 2
    @ucItemsList = []
    window_update(items, dataview)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     items : items list
  #--------------------------------------------------------------------------
  def window_update(items, dataview=nil)
    @data = []
    if dataview != nil
      items = apply_dataview(dataview, items)
    end
    
    if items != nil
      for item in items
        if item != nil && include?(item)
          @data.push(item)
          if item.is_a?(RPG::Item) and item.id == $game_party.last_item_id
            self.index = @data.size - 1
          end
        end
      end
      @item_max = @data.size
      create_contents()
      @ucItemsList.clear()
      for i in 0..@item_max-1
        @ucItemsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucItemsList.each() { |ucItem| ucItem.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(item == nil ? "" : item.description)
    else
      if selected_item != nil
        @help_window.window_update(selected_item.description)
      else
        @help_window.window_update("")
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_item != nil
      @detail_window.window_update(selected_item)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_item != nil && 
           ((selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_ItemDetails)) ||
           (!selected_item.is_a?(RPG::Item) && detail_window.is_a?(Window_EquipDetails)))
  end
  
  #--------------------------------------------------------------------------
  # * Draw a specific item
  #--------------------------------------------------------------------------
  def draw_item(index)
    rect = item_rect(index)
    self.contents.clear_rect(rect)
    item = create_item(index)
    item.draw()
  end
  
  #--------------------------------------------------------------------------
  # * Return true if there are items in the list else false
  #--------------------------------------------------------------------------
  def hasItems
    return @ucItemsList.size > 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index, true)
    
    ucItem = UCItem.new(self, item, rect)
    ucItem.active = enable?(item)
    
    if $game_party.newest_items.include?(item)
      ucItem.cItemName.font.color = Color.new_item_color
      ucItem.cItemNumber.font.color = Color.new_item_color
    end
                              
    return ucItem
  end
  private :create_item
  
  #--------------------------------------------------------------------------
  # * Apply dataview to a list
  #     list : data to apply the dataview
  #--------------------------------------------------------------------------
  def apply_dataview(dataview, list)
    new_list = []
    
    if dataview.is_a?(Comparer)
      new_list = list.sort{|x,y| dataview.compare(x,y)}
    elsif dataview.is_a?(Filter)
      new_list = list.find_all{|x| dataview.apply(x)}
    end
    
    return new_list
  end
  private :apply_dataview
  
end

#===============================================================================
# ** Window_Dataviews
#------------------------------------------------------------------------------
#  This window displays views that can be applied to filter or sort lists
#===============================================================================

class Window_Dataviews < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of dataviews (filters or comparers)
  attr_reader :viewsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current comparer
  #--------------------------------------------------------------------------
  # GET
  def selected_view
    return @data[self.index].view
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     views : views list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, views)
    super(x, y, width, height, 8, 24, true, 24, 2)
    @row_max = 1
    @column_max = views.size
    
    @viewsList = []
    window_update(views)
    self.index = 0
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     views : views list
  #--------------------------------------------------------------------------
  def window_update(views)
    @data = []
    if views != nil
      for view in views
        if view != nil
          @data.push(view)
        end
      end
      @item_max = @data.size
      create_contents()
      @viewsList.clear()
      for i in 0..@item_max-1
        @viewsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @viewsList.each() { |view| view.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the views list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    dataview = @data[index]
    rect = item_rect(index)
    
    viewItem = UCLabelIcon.new(self, Rect.new(rect.x,rect.y,24,24),
                              Rect.new(rect.x,rect.y,24,24),
                              dataview.label,
                              dataview.icon_index)
    
    viewItem.cLabel.align = 1
    
    return viewItem
  end
  private :create_item
  
end

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

#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays a list of usable skills on the skill screen, etc.
#==============================================================================

class Window_Skill < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCSkill for every skill of a character
  attr_reader :ucSkillsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_skill
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, dataview=nil)
    super(x, y, width, height)
    @column_max = 1
    @ucSkillsList = []
    window_update(actor, dataview)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor, dataview=nil)
    @data = []
    if actor != nil
      @actor = actor
      if dataview != nil
        skills = apply_dataview(dataview, actor.skills)
      else
        skills = actor.skills
      end
      
      for skill in skills
        if skill != nil
          @data.push(skill)
          if skill.id == actor.last_skill_id
            self.index = @data.size - 1
          end
        end
      end
      @item_max = @data.size
      create_contents()
      @ucSkillsList.clear()
      for i in 0..@item_max-1
        @ucSkillsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucSkillsList.each() { |ucSkill| ucSkill.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(skill == nil ? "" : skill.description)
    else
      if selected_skill != nil
        @help_window.window_update(selected_skill.description)
      else
        @help_window.window_update("")
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_skill != nil
      @detail_window.window_update(selected_skill)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_skill != nil && selected_skill.is_a?(RPG::Skill)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     skill : skill
  #--------------------------------------------------------------------------
  def enable?(skill)
    return @actor.skill_can_use?(skill)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    skill = @data[index]
    rect = item_rect(index, true)
    
    ucSkill = UCSkill.new(self, skill, rect, @actor.calc_mp_cost(skill))
    ucSkill.active = enable?(skill)
    
    return ucSkill
  end
  private :create_item
  
  #--------------------------------------------------------------------------
  # * Apply dataview to a list
  #     list : data to apply the dataview
  #--------------------------------------------------------------------------
  def apply_dataview(dataview, list)
    new_list = []
    
    if dataview.is_a?(Comparer)
      new_list = list.sort{|x,y| dataview.compare(x,y)}
    elsif dataview.is_a?(Filter)
      new_list = list.find_all{|x| dataview.apply(x)}
    end
    
    return new_list
  end
  private :apply_dataview
  
end

#==============================================================================
# ** Window_Equip_Compare_Status
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen, etc.
#==============================================================================

class Window_Equip_Compare_Status < Window_Scrollable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCompareCharStatus for the equipment status compare
  attr_reader :ucCompareStat
  # Label for the Elemental Resistance graph
  attr_reader :cElementalResistLabel
  # Elemental Resistance graph
  attr_reader :ucElementalResistGraph
  # Label for the States Resistance graph
  attr_reader :cStatesResistLabel
  # States Resistance graph
  attr_reader :ucStatesResistGraph
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
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
    
    self.contents.dispose
    self.contents = Bitmap.new((self.width - 32)*2, self.height - 32)
    
    width = ((self.contents.width)/2).floor
    
    @actor = actor
    
    @ucCompareStat = UCCompareCharStatus.new(self, actor, Rect.new(0,0,width,self.contents.height))
    
    @cElementalResistLabel = CLabel.new(self, Rect.new(width,0,185,WLH), Vocab::elem_resist_label)

    @ucElementalResistGraph = UCGraph.new(self, width+100, 85, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                          MENU_CONFIG::ELEM_RES_MAX,
                                          MENU_CONFIG::ELEM_RES_MIN,
                                          Font.graph_label_font,
                                          Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                          Color.neg_resist_gauge_color1, Color.neg_resist_gauge_color2, 
                                          nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                               
    @cStatesResistLabel = CLabel.new(self, Rect.new(width,160,185,WLH), Vocab::states_resist_label)
    
    @ucStatesResistGraph = UCGraph.new(self, width+100,245, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                       MENU_CONFIG::STATES_RES_MAX,
                                       MENU_CONFIG::STATES_RES_MIN,
                                       Font.graph_label_font,
                                       Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                       nil, nil,
                                       nil, 2, Color.resist_border_color1, Color.resist_border_color2)
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    # Scroll
    if self.active
      scroll_max = [self.contents.width - (self.width - 32), 0].max
      if Input.press?(Input::Y)
        self.ox = [self.ox - (self.width - 32), 0].max
      elsif Input.press?(Input::Z)
        self.ox = [self.ox + (self.width - 32), scroll_max].min
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(equipIndex, newItem)
    if equipIndex != nil && newItem != nil
      # Test equipment with a clone to compare stats
      compare_actor = @actor.clone
      compare_actor.change_equip(equipIndex, newItem, true)
      
      @ucCompareStat.update_status(compare_actor)
      
      #------------------------------------------
      # Resistances section
      #------------------------------------------
      elements = []
      for i in 9..16       
        elements.push(GraphElement.new(CORE_CONFIG::ELEMENT_ICONS[i], compare_actor.element_rate(i)))
      end
      @ucElementalResistGraph.elements = elements

      elements = []
      for i in 1 .. $data_states.size-1
        state = $data_states[i]
        if !state.nonresistance         
          elements.push(GraphElement.new(state.icon_index, compare_actor.state_probability(state.id)))
        end
      end
      @ucStatesResistGraph.elements = elements
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCompareStat.draw()
    @cElementalResistLabel.draw()
    @ucElementalResistGraph.draw()
    @cStatesResistLabel.draw()
    @ucStatesResistGraph.draw()
  end
  
end

#==============================================================================
# ** Window_Equip_Item
#------------------------------------------------------------------------------
#  This window displays choices when opting to change equipment on the
# equipment screen.
#==============================================================================

class Window_Equip_Item < Window_Item
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Equip type used for the choices of equipment in the window
  attr_accessor :equip_type
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the current equip type
  #--------------------------------------------------------------------------
  # SET
  def equip_type=(equip_type)
    if equip_type == 1 and @actor.two_swords_style
      equip_type = 0                              # Change shield to weapon
    end
    @equip_type = equip_type
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #     equip_type : equip region (0-4)
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, equip_type)
    @actor = actor
    @equip_type = equip_type
    super(x, y, width, height, nil)
    @column_max = 1
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Whether to include item in list
  #     item : item
  #--------------------------------------------------------------------------
  def include?(item)
    return true if item == nil
    if @equip_type == 0
      return false unless item.is_a?(RPG::Weapon)
    else
      return false unless item.is_a?(RPG::Armor)
      return false unless item.kind == @equip_type - 1
    end
    return @actor.equippable?(item)
  end
  
  #--------------------------------------------------------------------------
  # * Whether to display item in enabled state
  #     item : item
  #--------------------------------------------------------------------------
  def enable?(item)
    return true
  end
  
end

#==============================================================================
# ** Window_Slot_List
#------------------------------------------------------------------------------
#  This window displays save slots list
#==============================================================================

class Window_Slot_List < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCLabelIcon for every save slot
  attr_reader :ucSavesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current save
  #--------------------------------------------------------------------------
  # GET
  def selected_save
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     saves : saves list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, saves)
    super(x, y, width, height)
    @column_max = 1
    @ucSavesList = []
    window_update(saves)
    self.index = 0
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     saves : saves list
  #--------------------------------------------------------------------------
  def window_update(saves)
    @data = []
    if saves != nil
      for save in saves
        if save != nil
          @data.push(save)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucSavesList.clear()
      for i in 0..@item_max-1
        @ucSavesList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucSavesList.each() { |ucSave| ucSave.draw() }
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SavesList
  #     index : save index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index)
    
    if item.used
      icon_index = Wora_NSS::SAVED_SLOT_ICON
    else
      icon_index = Wora_NSS::EMPTY_SLOT_ICON
    end
    
    ucSave = UCLabelIcon.new(self, Rect.new(rect.x+24,rect.y,rect.width-24-32-2,24), 
                             Rect.new(rect.x,rect.y,24,24),
                             item.slot_name, icon_index, item.used)
                              
    return ucSave
  end
  private :create_item
  
end

#==============================================================================
# ** Window_Slot_Details
#------------------------------------------------------------------------------
#  This window displays save slot details
#==============================================================================

class Window_Slot_Details < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label when the save slot is empty
  attr_reader :cEmptyLabel
  # UCImageBorder for the screenshot when the game was saved
  attr_reader :ucScreenshot
  # UCLabelValue for the location (or map) name
  attr_reader :ucLocation
  # UCLabelIcon for the current time
  attr_reader :ucTime
  # UCLabelIcon for the party's gold
  attr_reader :ucGold
  # Array for UCSaveCharStatus for the status of each member of the party
  attr_reader :ucCharFacesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     slot_id : save slot id
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, slot_id)
    super(x, y, width, height)
    
    @cEmptyLabel = CLabel.new(self, Rect.new(0,0, contents.width, contents.height - WLH), Wora_NSS::EMPTY_SLOT_TEXT, 1)

    @ucTime = UCLabelIcon.new(self, Rect.new(368,0,80,WLH), Rect.new(342,0,24,24), "", 188)
    @ucTime.cLabel.align = 2
    @ucTime.visible = Wora_NSS::DRAW_PLAYTIME
    
    @ucGold = UCLabelIcon.new(self, Rect.new(230,0,80,WLH), Rect.new(206,0,24,24), "", 147)
    @ucGold.cLabel.align = 2
    @ucGold.visible = Wora_NSS::DRAW_GOLD
    
    @ucScreenshot = UCImageBorder.new(self, Rect.new(0, 30, contents.width, 176), nil, nil, 
                                     0, 255, 0, 2, Color.image_border_color)
    @ucScreenshot.visible = Wora_NSS::SCREENSHOT_IMAGE
    
    @ucLocation = UCLabelValue.new(self, Rect.new(0,0,80,WLH), 
                                   Rect.new(0,@ucScreenshot.cImage.rect.height-18,
                                            @ucScreenshot.cImage.rect.width-2,(WLH*2)),
                                   Vocab::save_location_label, "")
    @ucLocation.visible = Wora_NSS::DRAW_LOCATION
    @ucLocation.cLabel.font = Font.bold_font
    @ucLocation.cValue.align = 2
    @ucLocation.cValue.font = Font.save_location_font
    @ucLocation.cValue.cut_overflow = true
    
    @ucCharFacesList = []
    
    window_update(slot_id)
  end

  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     save_data : save data
  #--------------------------------------------------------------------------
  def window_update(save_data)
    if save_data != nil
      @save_data = save_data
      if save_data.used
        # DRAW SCREENSHOT
        if Wora_NSS::SCREENSHOT_IMAGE  
          if !@ucScreenshot.cImage.img_bitmap.nil?
            @ucScreenshot.cImage.img_bitmap.dispose
          end
          @ucScreenshot.cImage.img_bitmap = Bitmap.read_png(save_data.screenshot_stream)
          @ucScreenshot.cImage.src_rect = Rect.new((@ucScreenshot.cImage.img_bitmap.width-@ucScreenshot.cImage.rect.width)/2,
                                            (@ucScreenshot.cImage.img_bitmap.height-@ucScreenshot.cImage.rect.height)/2,
                                             @ucScreenshot.cImage.rect.width, @ucScreenshot.cImage.rect.height)
        end
       #else 
       # if SWAP_TILE and $game_switches[SWAP_TILE_SWITCH]
       #   create_swaptilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
       #   save_data['gamemap'].display_y)
       # else
       #   create_tilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
       #   save_data['gamemap'].display_y)
       # end
       #end
       
        # DRAW GOLD
        if Wora_NSS::DRAW_GOLD
          @ucGold.cLabel.text = save_data.game_par.gold
        end
        
        # DRAW PLAYTIME
        if Wora_NSS::DRAW_PLAYTIME
          @total_sec = save_data.frame_count / Graphics.frame_rate
          hour = @total_sec / 60 / 60
          min = @total_sec / 60 % 60
          sec = @total_sec % 60
          @ucTime.cLabel.text = sprintf(MENU_CONFIG::TIME_PATTERN, hour, min, sec)
        end
        
        # DRAW LOCATION
        if Wora_NSS::DRAW_LOCATION
          @ucLocation.cValue.text = save_data.game_map.name
        end
        
        # DRAW FACE & Level & Name
        @ucCharFacesList.clear()
        save_data.game_par.members.each_index do |i|
          actor = save_data.game_act[save_data.game_par.members[i].id]
          x_base = (i*100) + (i*16)
          @ucCharFacesList.push(UCSaveCharStatus.new(self, actor, Rect.new(x_base, 208, 100, 182)))
        end
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    if @save_data != nil
      if @save_data.used
        @ucTime.draw()
        @ucGold.draw()
        #contents.fill_rect(@cScreenshot.rect.x-2, @cScreenshot.rect.y-2, 
        #                   @cScreenshot.rect.width+4, @cScreenshot.rect.height+4,
        #                   Wora_NSS::MAP_BORDER)
        @ucScreenshot.draw()
        @ucLocation.draw()
        @ucCharFacesList.each() { |ucCharFace| ucCharFace.draw() }
      else
        @cEmptyLabel.draw()
      end
    else
      @cEmptyLabel.draw()
    end
  end
  
end

#===============================================================================
# ** Window_Optimize_Modes
#------------------------------------------------------------------------------
#  This window displays optimize modes in the equip screen
#===============================================================================

class Window_Optimize_Modes < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of optimize modes
  attr_reader :modesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current mode
  #--------------------------------------------------------------------------
  # GET
  def selected_mode
    return @data[self.index]
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window x-coordinate
  #     y : window y-coordinate
  #     width : window width
  #     height : window height
  #     modes : optimize modes list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, modes)
    super(x, y, width, height, 32, 32)
    
    @row_max = modes.size
    @column_max = 1
    
    @modesList = []
    window_update(modes)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     modes : optimize modes list
  #--------------------------------------------------------------------------
  def window_update(modes)
    @data = []
    if modes != nil
      for mode in modes
        if mode != nil
          @data.push(mode)
        end
      end
      @item_max = @data.size
      create_contents()
      @modesList.clear()
      for i in 0..@item_max-1
        @modesList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @modesList.each() { |mode| mode.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if selected_mode != nil
      @help_window.window_update(selected_mode.description)
    else
      @help_window.window_update("")
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the modes list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    mode = @data[index]
    rect = item_rect(index)
    
    modeItem = CLabel.new(self, rect, mode.name, 1, Font.optimize_mode_font)

    return modeItem
  end
  private :create_item
  
end

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

#===============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a superclass of all windows in the game. 
#===============================================================================

class Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # Get Current Windowskin Settings
  #--------------------------------------------------------------------------
  # GET
  def current_windowskin_settings
    if $game_variables != nil
      winvar = YE::SYSTEM::WINDOW_VARIABLE
      if $game_variables[winvar] == 0
        $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
      elsif !MENU_CONFIG::WINDOW_HASH.include?($game_variables[winvar])
        $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
      end
      mso_windowskin = MENU_CONFIG::WINDOW_HASH[$game_variables[winvar]]
    else
      mso_windowskin = MENU_CONFIG::WINDOW_HASH[YE::SYSTEM::DEFAULT_WINDOW]
    end
    return mso_windowskin
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_window_mso initialize unless $@
  def initialize(x, y, width, height)
    self.update_windowskin_font
    initialize_window_mso(x, y, width, height)
    self.update_windowskin
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Update windowskin
  #--------------------------------------------------------------------------
  def update_windowskin
    mso_windowskin = current_windowskin_settings()
    
    self.windowskin = Cache.windows(mso_windowskin[1])
    self.opacity = mso_windowskin[2]
    self.back_opacity = mso_windowskin[3]
  end
  
  #--------------------------------------------------------------------------
  # Update windowskin font
  #--------------------------------------------------------------------------
  def update_windowskin_font
    mso_windowskin = current_windowskin_settings()
    
    # Changes default font settings
    Font.default_bold = mso_windowskin[4][0]
    Font.default_italic = mso_windowskin[4][1]
    Font.default_shadow = mso_windowskin[4][2]
    Font.default_size = mso_windowskin[4][3]
    Font.default_name = mso_windowskin[4][4]
  end
    
end
#==============================================================================
# ** Window_Outline
#------------------------------------------------------------------------------
# Plot (content) to display window.
#==============================================================================

class Window_Outline < Window_Scrollable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Controls list to show the outline
  attr_reader :cControlsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     oline : outline non-parsed text
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, oline=nil)
    super(x, y, width, height, KGC::Outline::OLINE_SCROLL_SPEED)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
    
    @cControlsList = []
    window_update(oline)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     oline : outline non-parsed text
  #--------------------------------------------------------------------------
  def window_update(oline)
    if oline != nil
      #text = ""
      @last_color = 0
      @contents_x = 0
      @contents_y = 0
      @biggest_text_height = 0
      @cControlsList.clear()
      for l in oline
        next if l == nil
        converted_line = convert_special_characters(l)
        generate_controls(converted_line)
        new_line
      end

      # Changes contents size for scrolling
      self.contents.dispose
      self.contents = Bitmap.new(self.width - 32, [self.height - 32, @contents_y].max)
      self.oy = 0
    end
    
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cControlsList.each() { |control| control.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Convert special characters from the outline text
  #     text : outline text
  #--------------------------------------------------------------------------
  def convert_special_characters(text)
    converted_text = text.clone
    #--------------------------
    # DEFAULT FEATURES
    #-----------------------
    converted_text.gsub!(/\\V\[([0-9]+)\]/i) { $game_variables[$1.to_i] }
    converted_text.gsub!(/\\N\[([0-9]+)\]/i) { $game_actors[$1.to_i].name }
    converted_text.gsub!(/\\C\[([0-9]+)\]/i) { "\x01[#{$1}]" }
    
    #--------------------------
    # * NMS FEATURES!!
    #-----------------------
    # Woratana's :: Draw Weapon Name + Icon
    converted_text.gsub!(/\\DW\[([0-9]+)\]/i) { "\x83[#{$data_weapons[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::WEAPON_NAME_COLOR_ID}]\\nw[#{$1.to_i}]\x01[#{@last_color}]"}
    # Woratana's :: Draw Item Name + Icon
    converted_text.gsub!(/\\DI\[([0-9]+)\]/i) { "\x83[#{$data_items[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::ITEM_NAME_COLOR_ID}]\\ni[#{$1.to_i}]\x01[#{@last_color}]" }
    # Woratana's :: Draw Armor Name + Icon
    converted_text.gsub!(/\\DA\[([0-9]+)\]/i) { "\x83[#{$data_armors[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::ARMOR_NAME_COLOR_ID}]\\na[#{$1.to_i}]\x01[#{@last_color}]"}
    # Woratana's :: Draw Skill Name + Icon
    converted_text.gsub!(/\\DS\[([0-9]+)\]/i) { "\x83[#{$data_skills[$1.to_i].icon_index}]\x01[#{MENU_CONFIG::SKILL_NAME_COLOR_ID}]\\ns[#{$1.to_i}]\x01[#{@last_color}]"}

    # Woratana's :: Draw Icon
    converted_text.gsub!(/\\IC\[([0-9]+)\]/i) { "\x83[#{$1}]" }

    # Woratana's :: Actor Class Name
    converted_text.gsub!(/\\NC\[([0-9]+)\]/i) { $data_classes[$game_actors[$1.to_i].class_id].name }
    # Woratana's :: Party Actor Name
    converted_text.gsub!(/\\NP\[([0-9]+)\]/i) { $game_party.members[($1.to_i - 1)].name }
    # Woratana's :: Monster Name
    converted_text.gsub!(/\\NM\[([0-9]+)\]/i) { $data_enemies[$1.to_i].name }
    # Woratana's :: Troop Name
    converted_text.gsub!(/\\NT\[([0-9]+)\]/i) { $data_troops[$1.to_i].name }
    # Woratana's :: Item Name
    converted_text.gsub!(/\\NI\[([0-9]+)\]/i) { $data_items[$1.to_i].name }
    # Woratana's :: Weapon Name
    converted_text.gsub!(/\\NW\[([0-9]+)\]/i) { $data_weapons[$1.to_i].name }
    # Woratana's :: Armor Name
    converted_text.gsub!(/\\NA\[([0-9]+)\]/i) { $data_armors[$1.to_i].name }
    # Woratana's :: Skill Name
    converted_text.gsub!(/\\NS\[([0-9]+)\]/i) { $data_skills[$1.to_i].name }
    # Woratana's :: Item Price
    converted_text.gsub!(/\\PRICE\[([0-9]+)\]/i) { $data_items[$1.to_i].price.to_s }
    
    # Woratana's :: Font Name Change
    converted_text.gsub!(/\\FN\[(.*?)\]/i) { "\x84[#{$1}]" }
    # Woratana's :: Font Size Change
    converted_text.gsub!(/\\FS\[([0-9]+)\]/i) { "\x85[#{$1}]" }
    # Woratana's :: Reset Font Name
    converted_text.gsub!(/\\REF/i) { "\x86" }
    # Woratana's :: Reset Font Size
    converted_text.gsub!(/\\RES/i) { "\x87" }
    # Woratana's :: BOLD Text
    converted_text.gsub!(/\\B/i) { "\x88" }
    # Woratana's :: ITALIC Text
    converted_text.gsub!(/\\I/i) { "\x89" }
     
    # NMS 2++
    # Woratana's :: SHADOW Text
    converted_text.gsub!(/\\SH/i) { "\x93" }

    # Woratana's :: Draw Picture
    converted_text.gsub!(/\\DP\[(.*?),SIZE\{([0-9]+),([0-9]+)\},BORDER\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{$2},#{$3},#{$4},#{$5}]" }
    converted_text.gsub!(/\\DP\[(.*?),SIZE\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{$2},#{$3},#{nil},#{nil}]" }
    converted_text.gsub!(/\\DP\[(.*?),BORDER\{([0-9]+),([0-9]+)\}\]/i) { "\x11[#{$1},#{nil},#{nil},#{$2},#{$3}]" }
    converted_text.gsub!(/\\DP\[(.*?)\]/i) { "\x11[#{$1}]" }
    
    # Woratana's :: Draw Face
    converted_text.gsub!(/\\FA\[([0-9]+)\]/i) { "\x12[#{$1}]" }
    
    return converted_text
  end
  private :convert_special_characters
  
  #--------------------------------------------------------------------------
  # * Generate dynamically the controls from the outline text
  #     text : outline text
  #--------------------------------------------------------------------------
  def generate_controls(text)
    contents_text = ""
    loop do
      c = text.slice!(/./m)
      case c
      when nil
        break
    #--------------------------
    # DEFAULT FEATURES
    #-----------------------
      when "\x01"
        text.sub!(/\[([0-9]+)\]/, "")
        @last_color = $1.to_i
        contents.font.color = text_color($1.to_i)
        
    #--------------------------
    # * NMS FEATURES!!
    #-----------------------
      when "\x83"
        text.sub!(/\[([0-9]+)\]/, "")

        new_line if (@contents_x + 24 > contents.width)

        # Draw ICON
        ucIcon = UCIcon.new(self, Rect.new(@contents_x, @contents_y, 24, 24), $1.to_i)
        @cControlsList.push(ucIcon)
        @contents_x += 24
      when "\x84"
        text.sub!(/\[(.*?)\]/, "")
        contents.font.name = $1.to_s
      when "\x85"
        text.sub!(/\[([0-9]+)\]/, "")
        contents.font.size = $1.to_i
      when "\x86"
        contents.font.name = Font.default_name 
      when "\x87"
        contents.font.size = Font.default_size
      when "\x88"
        contents.font.bold = contents.font.bold == true ? false : true
      when "\x89"
        contents.font.italic = contents.font.italic == true ? false : true
      when "\x93"
        contents.font.shadow = contents.font.shadow == true ? false : true
      when "\x11"
        text.sub!(/\[(.*?)\]/, "")
        a = $1.to_s.split(',')
        bitmap = Cache.picture(a[0])

        new_line if (@contents_x + bitmap.width > contents.width)
        
        # Size
        if !a[1].nil? && !a[1].empty?
          width = a[1].to_i
        else
          width = bitmap.width
        end
        if !a[2].nil? && !a[2].empty?
          height = a[2].to_i
        else
          height = bitmap.height
        end
      
        # Border
        if !a[3].nil? && !a[3].empty?
          border = a[3].to_i 
        else
          border = 0
        end
        if !a[4].nil? && !a[4].empty?
          border_color = text_color(a[4].to_i)
        else
          border_color = nil
        end

        # Draw Image
        ucImageBorder = UCImageBorder.new(self, Rect.new(@contents_x, @contents_y, width, height),
                                          bitmap, Rect.new(0,0, width-border*2, height-border*2),
                                          0, 255, 0, border, border_color)
        @cControlsList.push(ucImageBorder)
        
        @contents_x += width
        @biggest_text_height = height if height > @biggest_text_height
        #bitmap.dispose
      when "\x12"
        text.sub!(/\[([0-9]+)\]/, "")

        new_line if (@contents_x + 96 > contents.width)

        # Draw Face
        actor = Game_Actor.new($1.to_i)
        ucCharFace = UCCharacterFace.new(self, Rect.new(@contents_x, @contents_y, 96, 96), actor)
        @cControlsList.push(ucCharFace)
        
        @biggest_text_height = 96 if 96 > @biggest_text_height
      else
        # Draw Text
        next_char = text.slice(/./m)
        contents_text += c
        if next_char == nil || next_char.match(/[\x01-\x12\x80-\xff]/) != nil
          text_height = contents.get_text_height(contents_text)
          if text_height < WLH
            text_height = WLH
          end
          @biggest_text_height = text_height if text_height > @biggest_text_height

          rect = Rect.new(@contents_x, @contents_y, contents.width, @biggest_text_height)
          cLabel = CLabel.new(self, rect, contents_text, 0, contents.font.clone, 
                              true, false, 3)
          @cControlsList.push(cLabel)
          
          lines = contents.split_multiline(rect, contents_text, 3)
          if lines.size > 1
            text_height = contents.get_text_height(contents_text)
            if text_height < WLH
              text_height = WLH
            end
            text_height = @biggest_text_height + text_height * (lines.size-2)
            @biggest_text_height = text_height if text_height > @biggest_text_height
            new_line
          end

          contents_text = ""
          @contents_x += contents.get_text_width(lines[lines.size-1])
        end
        
      end
    end

  end
  private :generate_controls
  
  #--------------------------------------------------------------------------
  # * Creates a new line
  #--------------------------------------------------------------------------
  def new_line
    biggest = @biggest_text_height > WLH ? @biggest_text_height : WLH
    @contents_x = 0 
    @contents_y += biggest
    @biggest_text_height = WLH
  end
  private :new_line
  
end

#==============================================================================
# ** Window_Outline_Title
#------------------------------------------------------------------------------
# Plot Summary Title Window Display
#==============================================================================

class Window_Outline_Title < Window_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the title
  attr_reader :cTitle
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     text : text to display
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, text=nil)
    super(x, y, width, height)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
    
    @cTitle = CLabel.new(self, Rect.new(0,0,width-32,WLH), "", 1, Font.bold_font)
    
    window_update(text)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     text : text to display
  #--------------------------------------------------------------------------
  def window_update(text)
    if text != nil
      @cTitle.text = text
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cTitle.draw()
  end
  
end

#==============================================================================
# ** Window_Outline_List
#------------------------------------------------------------------------------
# Plot Summary List Display Window
#==============================================================================

class Window_Outline_List < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of Labels for every outline
  attr_reader :cOutlinesList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get current outline info
  #--------------------------------------------------------------------------
  # GET
  def selected_outline
    return (self.index < 0 ? nil : @data[self.index])
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     outlines : outlines list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, outlines)
    super(x, y, width, height)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT

    @column_max = 1
    @cOutlinesList = []
    window_update(outlines)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     outlines : outlines list
  #--------------------------------------------------------------------------
  def window_update(outlines)
    @data = []
    if outlines != nil
      outlines.each_with_index { |oline, i|
        if $game_system.outline_enable[i]
          @data << OutlineList_Info.new(oline[0], oline[1], i)
        elsif !KGC::Outline::OLINE_HIDE_DISABLED
          @data << OutlineList_Info.new(KGC::Outline::OLINE_DISABLED_TITLE, nil, i)
        end
      }
      @item_max = @data.size
      create_contents()
      @cOutlinesList.clear()
      for i in 0..@item_max-1
        @cOutlinesList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cOutlinesList.each() { |cOutline| cOutline.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for OutlinesList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    item = @data[index]
    rect = item_rect(index)
    # Lists
    $game_system.outline_enable = [] if $game_system.outline_enable == nil
    $game_system.outline_complete = [] if $game_system.outline_complete == nil
    
    # Generate Title
    text = ($game_system.outline_complete[item.index] ?
      KGC::Outline::OLINE_COMPLETION_SYMBOL : KGC::Outline::OLINE_INCOMPLETION_SYMBOL) +
      (KGC::Outline::OLINE_SERIAL_NUMBER ? sprintf("%0*d : ",
      KGC::Outline::OLINE_SERIAL_NUMBER_DIGITS, item.index + 1) : "") +
      item.title

    cOutline = CLabel.new(self, rect, text)
    cOutline.active = $game_system.outline_enable[item.index]
    
    return cOutline
  end
  private :create_item
  
end

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

#==============================================================================
# ** UCCompareCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status (used to compare
#  status with different equipment)
#==============================================================================

class UCCompareCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCompareStat for the HP status of the character
  attr_reader :ucHpCompareStat
  # UCCompareStat for the MP status of the character
  attr_reader :ucMpCompareStat
  # UCCompareStat for the ATK status of the character
  attr_reader :ucAtkCompareStat
  # UCCompareStat for the DEF status of the character
  attr_reader :ucDefCompareStat
  # UCCompareStat for the SPI status of the character
  attr_reader :ucSpiCompareStat
  # UCCompareStat for the AGI status of the character
  attr_reader :ucAgiCompareStat
  # UCCompareStat for the EVA status of the character
  attr_reader :ucEvaCompareStat
  # UCCompareStat for the HIT status of the character
  attr_reader :ucHitCompareStat
  # UCCompareStat for the CRI status of the character
  attr_reader :ucCriCompareStat
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
    @ucHpCompareStat.visible = visible
    @ucMpCompareStat.visible = visible
    @ucAtkCompareStat.visible = visible
    @ucDefCompareStat.visible = visible
    @ucSpiCompareStat.visible = visible
    @ucAgiCompareStat.visible = visible
    @ucEvaCompareStat.visible = visible
    @ucHitCompareStat.visible = visible
    @ucCriCompareStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucHpCompareStat.active = active
    @ucMpCompareStat.active = active
    @ucAtkCompareStat.active = active
    @ucDefCompareStat.active = active
    @ucSpiCompareStat.active = active
    @ucAgiCompareStat.active = active
    @ucEvaCompareStat.active = active
    @ucHitCompareStat.active = active
    @ucCriCompareStat.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     actor : actor object
  #     rect : rectangle to position the controls for the actor
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, actor, rect, spacing=24,
                 active=true, visible=true)
    super(active, visible)
    @actor = actor
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucHpCompareStat = UCCompareStat.new(window, rects[0], 
                                         Vocab::hp_label, MENU_CONFIG::ICON_HP)
    @ucHpCompareStat.active = active
    @ucHpCompareStat.visible = visible
    
    @ucMpCompareStat = UCCompareStat.new(window, rects[1], 
                                         Vocab::mp_label, MENU_CONFIG::ICON_MP)
    @ucMpCompareStat.active = active
    @ucMpCompareStat.visible = visible
    
    @ucAtkCompareStat = UCCompareStat.new(window, rects[2], 
                                          Vocab::atk_label, MENU_CONFIG::ICON_ATK)
    @ucAtkCompareStat.active = active
    @ucAtkCompareStat.visible = visible
    
    @ucDefCompareStat = UCCompareStat.new(window, rects[3], 
                                          Vocab::def_label, MENU_CONFIG::ICON_DEF)
    @ucDefCompareStat.active = active
    @ucDefCompareStat.visible = visible
    
    @ucSpiCompareStat = UCCompareStat.new(window, rects[4], 
                                          Vocab::spi_label, MENU_CONFIG::ICON_SPI)
    @ucSpiCompareStat.active = active
    @ucSpiCompareStat.visible = visible
    
    @ucAgiCompareStat = UCCompareStat.new(window, rects[5], 
                                          Vocab::agi_label, MENU_CONFIG::ICON_AGI)
    @ucAgiCompareStat.active = active
    @ucAgiCompareStat.visible = visible
    
    @ucEvaCompareStat = UCCompareStat.new(window, rects[6], 
                                          Vocab::eva_label, MENU_CONFIG::ICON_EVA, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucEvaCompareStat.active = active
    @ucEvaCompareStat.visible = visible
    
    @ucHitCompareStat = UCCompareStat.new(window, rects[7], 
                                          Vocab::hit_label, MENU_CONFIG::ICON_HIT, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucHitCompareStat.active = active
    @ucHitCompareStat.visible = visible
    
    @ucCriCompareStat = UCCompareStat.new(window, rects[8], 
                                          Vocab::cri_label, MENU_CONFIG::ICON_CRI, MENU_CONFIG::PERCENTAGE_PATTERN)
    @ucCriCompareStat.active = active
    @ucCriCompareStat.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update status with new actor
  #     compareActor : actor object to compare
  #--------------------------------------------------------------------------
  def update_status(compareActor)
    @ucHpCompareStat.set_values(@actor.maxhp, compareActor.maxhp - @actor.maxhp)
    @ucMpCompareStat.set_values(@actor.maxmp, compareActor.maxmp - @actor.maxmp)
    @ucAtkCompareStat.set_values(@actor.atk, compareActor.atk - @actor.atk)
    @ucDefCompareStat.set_values(@actor.def, compareActor.def - @actor.def)
    @ucSpiCompareStat.set_values(@actor.spi, compareActor.spi - @actor.spi)
    @ucAgiCompareStat.set_values(@actor.agi, compareActor.agi -  @actor.agi)
    @ucEvaCompareStat.set_values(@actor.eva, compareActor.eva - @actor.eva)
    @ucHitCompareStat.set_values(@actor.hit, compareActor.hit - @actor.hit)
    @ucCriCompareStat.set_values(@actor.cri, compareActor.cri - @actor.cri)
  end
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucHpCompareStat.draw()
    @ucMpCompareStat.draw()
    @ucAtkCompareStat.draw()
    @ucDefCompareStat.draw()
    @ucSpiCompareStat.draw()
    @ucAgiCompareStat.draw()
    @ucEvaCompareStat.draw()
    @ucHitCompareStat.draw()
    @ucCriCompareStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[3] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[4] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[5] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[6] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[7] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[8] = Rect.new(rect.x,rect.y,rect.width,24)
    
    # Rects Adjustments
    
    # ucHpCompareStat
    # Nothing to do
    
    # ucMpCompareStat
    rects[1].y += spacing
    
    # ucAtkCompareStat
    rects[2].y += spacing*2
    
    # ucDefCompareStat
    rects[3].y += spacing*3
        
    # ucSpiCompareStat
    rects[4].y += spacing*4
    
    # ucAgiCompareStat
    rects[5].y += spacing*5
    
    # ucEvaCompareStat
    rects[6].y += spacing*6
    
    # ucHitCompareStat
    rects[7].y += spacing*7
    
    # ucCriCompareStat
    rects[8].y += spacing*8
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCCompareStat
#------------------------------------------------------------------------------
#  Represents a group of controls to show a stat compare
#==============================================================================

class UCCompareStat < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCLabelIconValue for the stat to compare
  attr_reader :ucStat
  # UCLabelValue for the difference of the stat
  attr_reader :ucCompareStat
  # Format to apply to the value of the stat (optional)
  attr_reader :format
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucStat.visible = visible
    @ucCompareStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucStat.active = active
    @ucCompareStat.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     rect : rectangle to position the control for the stat
  #     statLabel : label of the stat
  #     iconIndex : icon index of the stat
  #     format : format to apply to the value of the stat
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, rect, statLabel, iconIndex, format=nil, spacing=8,
                 active=true, visible=true)
    super(active, visible)   
    @format = format
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucStat = UCLabelIconValue.new(window, rects[0][1], rects[0][0], rects[0][2],
                                   statLabel, iconIndex, 0)
    @ucStat.cValue.align = 2
    @ucStat.visible = visible
    @ucStat.active = active

    @ucCompareStat = UCLabelValue.new(window, rects[1][0], rects[1][1],
                                      MENU_CONFIG::EQUIP_STATUS_SEPARATOR, 0)
    @ucCompareStat.cLabel.font = Font.party_stat_font
    @ucCompareStat.cLabel.align = 1
    @ucCompareStat.cValue.align = 2
    @ucCompareStat.visible = visible
    @ucCompareStat.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set values in the controls
  #     value : current stat value
  #     difference : difference between old and new stat
  #--------------------------------------------------------------------------
  def set_values(value, difference)
    @ucStat.cValue.text = value

    if difference > 0
      @ucCompareStat.cValue.font.color = Color.power_up_color
    elsif difference < 0
      @ucCompareStat.cValue.font.color = Color.power_down_color
    else
      @ucCompareStat.cValue.font.color = Color.normal_color
    end
    value += difference
    @ucCompareStat.cValue.text = value.abs.to_s
    
    if @format != nil
      @ucStat.cValue.text = sprintf(@format, @ucStat.cValue.text)
      @ucCompareStat.cValue.text = sprintf(@format, @ucCompareStat.cValue.text)
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucStat.draw()
    @ucCompareStat.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    
    value_width = ((rect.width - rects[0][0].width - rects[0][1].width - rects[1][0].width - spacing)/2).floor
    
    # Rects Adjustments
    
    # ucStat
    rects[0][1].x += rects[0][0].width
    rects[0][2].x = rects[0][1].x + rects[0][1].width
    rects[0][2].width = value_width
    
    # ucCompareStat
    rects[1][0].x = rects[0][2].x + rects[0][2].width + spacing
    rects[1][1].x = rects[1][0].x + rects[1][0].width
    rects[1][1].width = value_width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status
#==============================================================================

class UCCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Icons list for the actives states of the enemy
  attr_reader :ucActStates
  # UCLabelIconValue for the HP stat of the enemy
  attr_reader :ucHpStat
  # UCBar for the HP stat gauge of the enemy
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the MP stat of the enemy
  attr_reader :ucMpStat
  # UCBar for the MP stat gauge of the enemy
  attr_reader :cMpStatGauge
  # UCLabelIconValue for the ATK stat of the enemy
  attr_reader :ucAtkStat
  # UCLabelIconValue for the DEF stat of the enemy
  attr_reader :ucDefStat
  # UCLabelIconValue for the SPI stat of the enemy
  attr_reader :ucSpiStat
  # UCLabelIconValue for the AGI stat of the enemy
  attr_reader :ucAgiStat
  # UCLabelIconValue for the EVA stat of the enemy
  attr_reader :ucEvaStat
  # UCLabelIconValue for the HIT stat of the enemy
  attr_reader :ucHitStat
  # UCLabelIconValue for the CRI stat of the enemy
  attr_reader :ucCriStat
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
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
    @ucAtkStat.visible = visible
    @ucDefStat.visible = visible
    @ucSpiStat.visible = visible
    @ucAgiStat.visible = visible
    @ucEvaStat.visible = visible
    @ucHitStat.visible = visible
    @ucCriStat.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucActStates.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
    @ucAtkStat.active = active
    @ucDefStat.active = active
    @ucSpiStat.active = active
    @ucAgiStat.active = active
    @ucEvaStat.active = active
    @ucHitStat.active = active
    @ucCriStat.active = active
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
  def initialize(window, actor, rect, spacing=24, right_pad=2,
                 active=true, visible=true)
    super(active, visible)
    @actor = actor
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing, right_pad)
    
    @ucActStates = UCLabelIconsSwitchableList.new(window, rects[0][0], rects[0][1],  
                           Vocab::active_status_label, [0], MENU_CONFIG::ACT_STATES_MAX_ICONS, 
                           MENU_CONFIG::ACT_STATES_ICONS_TIMEOUT)  
    @ucActStates.active = active
    @ucActStates.visible = visible
    
    iconsArray = []
    for i in 0 .. actor.states.size-1
      iconsArray[i] = actor.states[i].icon_index
    end
    @ucActStates.icons = iconsArray
    
    @ucHpStat = UCLabelIconValue.new(window, rects[1][1], rects[1][0], rects[1][2],  
                                     Vocab::hp_label, MENU_CONFIG::ICON_HP, 
                                     sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.hp, actor.maxhp))
    @ucHpStat.cValue.align = 2
    
    if actor.hp == 0
      @ucHpStat.cValue.font.color = Color.knockout_color
    elsif actor.hp < actor.maxhp / 4
      @ucHpStat.cValue.font.color = Color.crisis_color
    else
      @ucHpStat.cValue.font.color = Color.normal_color
    end
    
    @ucHpStat.active = active
    @ucHpStat.visible = visible
    @cHpStatGauge = UCBar.new(window, rects[2], 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color,  
                              actor.hp, actor.maxhp, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[3][1], rects[3][0], rects[3][2],
                                     Vocab::mp_label, MENU_CONFIG::ICON_MP, 
                                     sprintf(MENU_CONFIG::GAUGE_PATTERN, actor.mp, actor.maxmp))
    @ucMpStat.cValue.align = 2
    
    if actor.mp < actor.maxmp / 4
      @ucMpStat.cValue.font.color = Color.crisis_color
    else
      @ucMpStat.cValue.font.color = Color.normal_color
    end
    
    @ucMpStat.active = active
    @ucMpStat.visible = visible
    @cMpStatGauge = UCBar.new(window, rects[4], 
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color,  
                              actor.mp, actor.maxmp, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
    value_width = rect.width - 24 - 50 - right_pad
    
    @ucAtkStat = UCLabelIconValue.new(window, rects[5][1], rects[5][0], rects[5][2],
                                      Vocab::atk_label, MENU_CONFIG::ICON_ATK, actor.atk)
    @ucAtkStat.cValue.align = 2
    @ucAtkStat.active = active
    @ucAtkStat.visible = visible
    
    @ucDefStat = UCLabelIconValue.new(window, rects[6][1], rects[6][0], rects[6][2],
                                      Vocab::def_label, MENU_CONFIG::ICON_DEF, actor.def)
    @ucDefStat.cValue.align = 2
    @ucDefStat.active = active
    @ucDefStat.visible = visible
    
    @ucSpiStat = UCLabelIconValue.new(window, rects[7][1], rects[7][0], rects[7][2],
                                      Vocab::spi_label, MENU_CONFIG::ICON_SPI, actor.spi)
    @ucSpiStat.cValue.align = 2
    @ucSpiStat.active = active
    @ucSpiStat.visible = visible
    
    @ucAgiStat = UCLabelIconValue.new(window, rects[8][1], rects[8][0], rects[8][2],
                                      Vocab::agi_label, MENU_CONFIG::ICON_AGI, actor.agi)
    @ucAgiStat.cValue.align = 2
    @ucAgiStat.active = active
    @ucAgiStat.visible = visible
    
    @ucEvaStat = UCLabelIconValue.new(window, rects[9][1], rects[9][0], rects[9][2],
                                      Vocab::eva_label, MENU_CONFIG::ICON_EVA, 
                                      sprintf(MENU_CONFIG::PERCENTAGE_PATTERN, actor.eva))
    @ucEvaStat.cValue.align = 2
    @ucEvaStat.active = active
    @ucEvaStat.visible = visible
    
    @ucHitStat = UCLabelIconValue.new(window, rects[10][1], rects[10][0], rects[10][2],
                                      Vocab::hit_label, MENU_CONFIG::ICON_HIT, 
                                      sprintf(MENU_CONFIG::PERCENTAGE_PATTERN, actor.hit))
    @ucHitStat.cValue.align = 2
    @ucHitStat.active = active
    @ucHitStat.visible = visible
    
    @ucCriStat = UCLabelIconValue.new(window, rects[11][1], rects[11][0], rects[11][2],
                                      Vocab::cri_label, MENU_CONFIG::ICON_CRI, 
                                      sprintf(MENU_CONFIG::PERCENTAGE_PATTERN, actor.cri))
    @ucCriStat.cValue.align = 2
    @ucCriStat.active = active
    @ucCriStat.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucActStates.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
    @ucAtkStat.draw()
    @ucDefStat.draw()
    @ucSpiStat.draw()
    @ucAgiStat.draw()
    @ucEvaStat.draw()
    @ucHitStat.draw()
    @ucCriStat.draw()
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
    rects[0] = [Rect.new(rect.x,rect.y,90,24),
                Rect.new(rect.x,rect.y,100,24)]
    rects[1] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[2] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[5] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[6] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[7] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[8] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[9] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,50,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[10] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    rects[11] = [Rect.new(rect.x,rect.y,24,24),
                 Rect.new(rect.x,rect.y,50,24),
                 Rect.new(rect.x,rect.y,rect.width,24)]
    
    gauge_value_width = rect.width - 24 - 25 - right_pad
    stats_value_width = rect.width - 24 - 50 - right_pad
    gauge_y = 16
        
    # Rects Adjustments
    
    # ucActStates
    rects[0][1].x += rects[0][0].width
    
    # ucHpStat
    rects[1][0].y += spacing
    rects[1][1].x += rects[1][0].width
    rects[1][1].y = rects[1][0].y
    rects[1][2].x = rects[1][1].x + rects[1][1].width
    rects[1][2].y = rects[1][0].y
    rects[1][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[2].y += rects[1][0].y+gauge_y
    rects[2].height = rects[1][0].height-gauge_y
    
    # ucMpStat
    rects[3][0].y += spacing*2
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].x = rects[3][1].x + rects[3][1].width
    rects[3][2].y = rects[3][0].y
    rects[3][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[4].y += rects[3][0].y+gauge_y
    rects[4].height = rects[3][0].height-gauge_y
    
    # ucAtkStat
    rects[5][0].y += spacing*3
    rects[5][1].x += rects[5][0].width
    rects[5][1].y = rects[5][0].y
    rects[5][2].x = rects[5][1].x + rects[5][1].width
    rects[5][2].y = rects[5][0].y
    rects[5][2].width = stats_value_width
    
    # ucDefStat
    rects[6][0].y += spacing*4
    rects[6][1].x += rects[6][0].width
    rects[6][1].y = rects[6][0].y
    rects[6][2].x = rects[6][1].x + rects[6][1].width
    rects[6][2].y = rects[6][0].y
    rects[6][2].width = stats_value_width
    
    # ucSpiStat
    rects[7][0].y += spacing*5
    rects[7][1].x += rects[7][0].width
    rects[7][1].y = rects[7][0].y
    rects[7][2].x = rects[7][1].x + rects[7][1].width
    rects[7][2].y = rects[7][0].y
    rects[7][2].width = stats_value_width
    
    # ucAgiStat
    rects[8][0].y += spacing*6
    rects[8][1].x += rects[8][0].width
    rects[8][1].y = rects[8][0].y
    rects[8][2].x = rects[8][1].x + rects[8][1].width
    rects[8][2].y = rects[8][0].y
    rects[8][2].width = stats_value_width
    
    # ucEvaStat
    rects[9][0].y += spacing*7
    rects[9][1].x += rects[9][0].width
    rects[9][1].y = rects[9][0].y
    rects[9][2].x = rects[9][1].x + rects[9][1].width
    rects[9][2].y = rects[9][0].y
    rects[9][2].width = stats_value_width
    
    # ucHitStat
    rects[10][0].y += spacing*8
    rects[10][1].x += rects[10][0].width
    rects[10][1].y = rects[10][0].y
    rects[10][2].x = rects[10][1].x + rects[10][1].width
    rects[10][2].y = rects[10][0].y
    rects[10][2].width = stats_value_width
    
    # ucCriStat
    rects[11][0].y += spacing*9
    rects[11][1].x += rects[11][0].width
    rects[11][1].y = rects[11][0].y
    rects[11][2].x = rects[11][1].x + rects[11][1].width
    rects[11][2].y = rects[11][0].y
    rects[11][2].width = stats_value_width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCEquipItem
#------------------------------------------------------------------------------
#  Represents an equip item on a window
#==============================================================================

class UCEquipItem < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the item kind
  attr_reader :cEquipKind
  # UCIcon for the item icon
  attr_reader :ucIcon
  # Label for the item name
  attr_reader :cEquipName
  # Item object
  attr_reader :equipItem
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cEquipKind.visible = visible
    @ucIcon.visible = visible
    @cEquipName.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cEquipKind.active = active
    @ucIcon.active = active
    @cEquipName.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     equipItem : item object
  #     rect : rectangle to position the controls for the item
  #     equipKindLabel : text to show for the item kind
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, equipItem, rect, equipKindLabel, 
                 active=true, visible=true)
    super(active, visible)
    @equipItem = equipItem
    
    @cEquipKind = CLabel.new(window, rect, equipKindLabel)
    @cEquipKind.active = active
    @cEquipKind.visible = visible
    
    if equipItem != nil
      icon_index = equipItem.icon_index
      name = equipItem.name
    else
      icon_index = nil
      name = nil
    end
    
    # Changes y to draw items under the equipkind label
    temp = Rect.new(rect.x,rect.y+rect.height,rect.width,rect.height)
    
    # Determine rectangles to position controls
    rects = determine_rects(temp)

    @ucIcon = UCIcon.new(window, rects[0], icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cEquipName = CLabel.new(window, rects[1], name)
    @cEquipName.active = active
    @cEquipName.visible = visible
    @cEquipName.cut_overflow = true
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @cEquipKind.draw()
    @ucIcon.draw()
    @cEquipName.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #--------------------------------------------------------------------------
  def determine_rects(rect)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cEquipName
    rects[1].x += rects[0].width
    rects[1].width -= rects[0].width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCItem
#------------------------------------------------------------------------------
#  Represents an item on a window
#==============================================================================

class UCItem < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the item icon
  attr_reader :ucIcon
  # Label for the item name
  attr_reader :cItemName
  # Label for the item quantity
  attr_reader :cItemNumber
  # Item object
  attr_reader :item
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cItemName.visible = visible
    @cItemNumber.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cItemName.active = active
    @cItemNumber.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     item : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, item, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @item = item
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], item.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cItemName = CLabel.new(window, rects[1], item.name)
    @cItemName.active = active
    @cItemName.visible = visible
    @cItemName.cut_overflow = true
    
    @cItemNumber = CLabel.new(window, rects[2], 
                              sprintf(MENU_CONFIG::ITEM_NUMBER_PATTERN, 
                                      $game_party.item_number(item)), 2)
    @cItemNumber.active = active
    @cItemNumber.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cItemName.draw()
    @cItemNumber.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,32,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cItemName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cItemNumber
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCSkill
#------------------------------------------------------------------------------
#  Represents a skill on a window
#==============================================================================

class UCSkill < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the skill icon
  attr_reader :ucIcon
  # Label for the skill name
  attr_reader :cSkillName
  # Label for the skill mp cost
  attr_reader :cSkillMpCost
  # Skill object
  attr_reader :skill
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cSkillName.visible = visible
    @cSkillMpCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cSkillName.active = active
    @cSkillMpCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     skill : skill object
  #     rect : rectangle to position the controls for the skill
  #     mpCost : skill mp cost
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, skill, rect, mpCost, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @skill = skill
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], skill.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cSkillName = CLabel.new(window, rects[1], skill.name)
    @cSkillName.active = active
    @cSkillName.visible = visible
    @cSkillName.cut_overflow = true
     
    @cSkillMpCost = CLabel.new(window, rects[2], 
                               sprintf(MENU_CONFIG::SKILL_COST_PATTERN, mpCost), 2)
    @cSkillMpCost.active = active
    @cSkillMpCost.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cSkillName.draw()
    @cSkillMpCost.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #     spacing : spacing between controls
  #--------------------------------------------------------------------------
  def determine_rects(rect, spacing)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,48,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cSkillName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cSkillMpCost
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCSaveCharStatus
#------------------------------------------------------------------------------
#  Represents a group of controls to show the character status in the custom save menu
#==============================================================================

class UCSaveCharStatus < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCharacterFace for the character's face
  attr_reader :ucCharFace
  # Label for the character's name
  attr_reader :cCharName
  # UCLabelValue for the character's level
  attr_reader :ucCharLvl
  # UCLabelIconValue for the character's HP
  attr_reader :ucHpStat
  # UCBar for the HP gauge of the character
  attr_reader :cHpStatGauge
  # UCLabelIconValue for the character's MP
  attr_reader :ucMpStat
  # UCBar for the MP gauge of the character
  attr_reader :cMpStatGauge
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
    @ucCharFace.visible = visible
    @cCharName.visible = visible
    @ucCharLvl.visible = visible
    @ucHpStat.visible = visible
    @cHpStatGauge.visible = visible
    @ucMpStat.visible = visible
    @cMpStatGauge.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucCharFace.active = active
    @cCharName.active = active
    @ucCharLvl.active = active
    @ucHpStat.active = active
    @cHpStatGauge.active = active
    @ucMpStat.active = active
    @cMpStatGauge.active = active
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
    
    @ucCharFace = UCCharacterFace.new(window, rects[0], actor)
    @ucCharFace.active = active
    @ucCharFace.visible = visible
    
    if actor.dead?
      @ucCharFace.active = false    
    end
    
    @cCharName = CLabel.new(window, rects[1], actor.name, 1, Font.bold_font)
    @cCharName.active = active
    @cCharName.visible = visible

    @ucCharLvl = UCLabelValue.new(window, rects[2][0], rects[2][1],
                                  Vocab::lvl_label, actor.level)
    @ucCharLvl.cLabel.font = Font.party_stat_font
    @ucCharLvl.cValue.font = Font.party_stat_font
    @ucCharLvl.cLabel.align = 1
    @ucCharLvl.cValue.align = 1
    @ucCharLvl.active = active
    @ucCharLvl.visible = visible
    
    @ucHpStat = UCLabelIconValue.new(window, rects[3][1], rects[3][0], rects[3][2],
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
    @cHpStatGauge = UCBar.new(window, rects[4], 
                              Color.hp_gauge_color1, Color.hp_gauge_color2, Color.gauge_back_color, 
                              actor.hp, actor.maxhp, 1, Color.gauge_border_color)
    @cHpStatGauge.active = active
    @cHpStatGauge.visible = visible
    
    @ucMpStat = UCLabelIconValue.new(window, rects[5][1], rects[5][0], rects[5][2], 
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
    @cMpStatGauge = UCBar.new(window, rects[6], 
                              Color.mp_gauge_color1, Color.mp_gauge_color2, Color.gauge_back_color, 
                              actor.mp, actor.maxmp, 1, Color.gauge_border_color)                    
    @cMpStatGauge.active = active
    @cMpStatGauge.visible = visible
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @ucCharFace.draw()
    @cCharName.draw()
    @ucCharLvl.draw()
    @cHpStatGauge.draw()
    @ucHpStat.draw()
    @cMpStatGauge.draw()
    @ucMpStat.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,96,96)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[2] = [Rect.new(rect.x,rect.y,rect.width,18),
                Rect.new(rect.x,rect.y,18,18)]
    rects[3] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[4] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[5] = [Rect.new(rect.x,rect.y,24,24),
                Rect.new(rect.x,rect.y,25,24),
                Rect.new(rect.x,rect.y,rect.width,24)]
    rects[6] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    gauge_value_width = rect.width - right_pad
    gauge_y = 16
    
    # Rects Adjustments
    
    # ucCharFace
    rects[0].x += ((rect.width - rects[0].width) / 2).floor
    rects[0].y += spacing*2
    
    # cCharName
    # Nothing to do
    
    # ucCharLvl
    rects[2][0].y += spacing
    rects[2][0].width -= rects[2][1].width
    rects[2][1].x += (rects[2][0].width / 2).floor + rects[2][1].width
    rects[2][1].y = rects[2][0].y
    
    # ucHpStat   
    rects[3][0].y += rect.height - spacing*4
    rects[3][1].x += rects[3][0].width
    rects[3][1].y = rects[3][0].y
    rects[3][2].y = rects[3][0].y + spacing
    rects[3][2].width = gauge_value_width
    
    # cHpStatGauge
    rects[4].y = rects[3][0].y+gauge_y
    rects[4].height = rects[3][0].height-gauge_y

    # ucMpStat
    rects[5][0].y += rect.height - spacing*2
    rects[5][1].x += rects[5][0].width
    rects[5][1].y = rects[5][0].y
    rects[5][2].y = rects[5][0].y + spacing
    rects[5][2].width = gauge_value_width
    
    # cMpStatGauge
    rects[6].y = rects[5][0].y+gauge_y
    rects[6].height = rects[5][0].height-gauge_y
    
    return rects
  end
  private :determine_rects
  
end

#==============================================================================
# ** UCVolumeControl
#------------------------------------------------------------------------------
#  Represents a group of controls to control volume
#==============================================================================

class UCVolumeControl < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the volume label
  attr_reader :cVolumeLabel
  # Label for the mute message
  attr_reader :cMuteLabel
  # UCBar for the volume gauge
  attr_reader :ucVolumeBar
  # Label for the volume value
  attr_reader :cVolumeValue
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cVolumeLabel.visible = visible
    @cMuteLabel.visible = visible
    @ucVolumeBar.visible = visible
    @cVolumeValue.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cVolumeLabel.active = active
    @cMuteLabel.active = active
    @ucVolumeBar.active = active
    @cVolumeValue.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     rect : rectangle to position the controls for the volume
  #     volumeLabel : Label for the label in the Label control for the volume
  #     bar_color1 : Color 1 of the volume bar
  #     bar_color2 : Color 2 of the volume bar (used for gradient)
  #     bar_back_color : Color of the background of the volume bar
  #     bar_border : volume bar border width
  #     bar_border_color : Color of the border of the volume bar
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, rect, volumeLabel, bar_color1, bar_color2, bar_back_color,
                 bar_border, bar_border_color,
                 active=true, visible=true)
    super(active, visible)
    
    # Determine rectangles to position controls
    rects = determine_rects(rect)
    
    @cVolumeLabel = CLabel.new(window, rects[0], volumeLabel, 0, Font.bold_font)
    @cVolumeLabel.active = active
    @cVolumeLabel.visible = visible
    
    @ucVolumeBar = UCBar.new(window, rects[1], bar_color1, bar_color2,
                             bar_back_color, 0, 100, bar_border, bar_border_color)
    @ucVolumeBar.active = active
    @ucVolumeBar.visible = visible
    
    @cMuteLabel = CLabel.new(window, rects[2], Vocab::system_mute_volume_label, 1)
    @cMuteLabel.active = active
    @cMuteLabel.visible = visible
    
    @cVolumeValue = CLabel.new(window, rects[3], 0, 1)
    @cVolumeValue.active = active
    @cVolumeValue.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     mute : true to mute the volume, else false
  #     volume : volume value
  #--------------------------------------------------------------------------
  def update(mute, volume)
    if mute
      vol = 0
      @cMuteLabel.visible = true
      @cVolumeValue.visible = false
    else
      vol = 100 - volume
      @cMuteLabel.visible = false
      @cVolumeValue.visible = true
    end
    @cVolumeValue.text = sprintf(MENU_CONFIG::VOL_PATTERN, vol)
    @ucVolumeBar.value = vol
  end
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @cVolumeLabel.draw()
    @ucVolumeBar.draw()
    @cMuteLabel.draw()
    @cVolumeValue.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #--------------------------------------------------------------------------
  def determine_rects(rect)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,20)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,20)
    rects[3] = Rect.new(rect.x,rect.y,rect.width,20)
    
    # Rects Adjustments
    
    # cVolumeLabel
    rects[0].width = (rect.width/3).floor
    
    # ucVolumeBar
    rects[1].x += rects[0].width
    rects[1].y += ((rect.height - rects[1].height)/2).floor
    rects[1].width -= rects[0].width
    
    # cMuteLabel
    rects[2].x += rects[0].width
    rects[2].y = rects[1].y
    rects[2].width = rects[1].width
      
    # cVolumeValue
    rects[3].x += rects[0].width
    rects[3].y = rects[1].y
    rects[3].width = rects[1].width
    
    return rects
  end
  private :determine_rects
  
end

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

