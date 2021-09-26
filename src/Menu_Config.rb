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
