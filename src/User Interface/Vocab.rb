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
