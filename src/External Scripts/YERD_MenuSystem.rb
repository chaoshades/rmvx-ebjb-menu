#===============================================================================
#
# Yanfly Engine RD - Menu System Options
# Last Date Updated: 2009.05.12
# Level: Easy, Normal
# 
# The "End Game" option is quite possibly the most useless function in RPG Maker
# VX games. Not only does it have little functionality but its functions can
# be reproduced by Alt+F4 and F12. This script replaces "End Game" with a new
# menu altogether and giving the player some familiar options seen in many of
# today's commercial RPG's such as changing window skins, adjust sound volume,
# turning off animations during battle, and the like.
#
#===============================================================================
# Updates:
# ----------------------------------------------------------------------------
# o 2009.05.12 - Auto-Dash update. If player holds down the dash button when
#                this option is enabled, the player will walk instead of dash.
# o 2009.05.09 - Compatibility update with Woratana's NeoMessage.
#                Compatibility update with Modern Algebra's ATS.
# o 2009.05.07 - Started script and finished.
#===============================================================================
# Instructions
#===============================================================================
#
# Input this script anywhere above Main. It's plug and play outside of changing
# a few variables and switches, which will be listed below:
#
# - If you have variables bound to variables 91, 92, 93, and 94, scroll down and
#   bind them to unused variables.
# - If you have switches bound to switches 91, 92, 93, 94, 95, or 96, scroll
#   down and bind them to unused switches.
#
# Then, download the windows pack, and create a "Windows" folder inside your
# Graphics folder. Input the windows pack there. You're all set to go.
#
#===============================================================================
#
# Compatibility
# - Works With: Woratana's NeoMessage
# - Works With: Modern Algebra's ATS
# - Alias: Game_Player: dash?
# - Alias: Window_Base: initialize
# - Alias: Scene_Battle: display_normal_animation
# - Overwrites: Scene_End: All of it
# - Overwrites: Vocab: game_end
#
#===============================================================================

$imported = {} if $imported == nil
$imported["MenuSystemOptions"] = true

module YE
  module SYSTEM
      
    # This changes the "End Game" string to a new string. This completely
    # overrides the default term from the database for a reason and that's
    # because this is adjustable from the title menu as well.
    TITLE = "System"
    
    #---------------------
    # Window Configuration
    #---------------------
    
    # This will affect what string data will appear for the window selection
    # portion of the system menu.
    WINDOW_HELP = "Select preferred window skin."
    WINDOW_SKIN = "Window Skin"
    
    # This sets the default window used when nothing is selected. This also
    # determines the window skin used at the title screen. Reference it to
    # the list below to determine which window skin. Don't make this 0.
    DEFAULT_WINDOW = 7
    
    # This determines the variable used to store the player's windowskin choice.
    WINDOW_VARIABLE = 91
    
#~     # This below determines what the variable refers to when it's used as
#~     # reference. Put your windows inside the Graphics/Windows folder. ID 0 will
#~     # automatically push back to the default window's ID.
#~     WINDOW_HASH ={
#~     # Window ID => Window Name
#~               1 => "Red",
#~               2 => "Orange",
#~               3 => "Yellow",
#~               4 => "Green",
#~               5 => "Cyan",
#~               6 => "Navy",
#~               7 => "Blue",
#~               8 => "Violet",
#~               9 => "Purple",
#~              10 => "Pink",
#~              11 => "Grey",
#~              12 => "Black",
#~     } # Do not remove this.
    
    #---------------------
    # Volume Configuration
    #---------------------
    
    # This will affect what string data will appear for the volume adjustment
    # portion of the system menu.
    BGM_HELP  = "Adjust BGM volume. Press L/R to mute."
    SFX_HELP  = "Adjust SFX volume. Press L/R to mute."
    BGS_HELP  = "Adjust BGS volume. Press L/R to mute."
    BGM_TITLE = "BGM Volume"
    SFX_TITLE = "SFX Volume"
    BGS_TITLE = "BGS Volume"
    VOL_MUTE  = "Mute"
    
    # These are the variables and switches that govern the sound effect volumes.
    # Note that for the variables, the higher they are, the lower the volume.
    BGM_VOLUME_VAR  = 92    # Variable
    SFX_VOLUME_VAR  = 93    # Variable
    BGS_VOLUME_VAR  = 94    # Variable
    BGM_MUTE_SWITCH = 92    # Switch
    SFX_MUTE_SWITCH = 93    # Switch
    BGS_MUTE_SWITCH = 94    # Switch
    
    # This adjusts the gradient colours for each of the volume controls.
    BGM_COLOUR1 = 30
    BGM_COLOUR2 = 31
    SFX_COLOUR1 = 28
    SFX_COLOUR2 = 29
    BGS_COLOUR1 = 20
    BGS_COLOUR2 = 21
    
    #---------------------
    # Battle Animations
    #---------------------
    
    # This will affect what string data will appear for the toggling of
    # battle animations portion of the system menu.
    ANI_TITLE = "Battle Animations"
    ANI_HELP  = "Toggles animations during battle."
    ANI_ON    = "Shown"
    ANI_OFF   = "Hidden"
    
    # This is the switch used to adjust battle animations. If it is off,
    # animations are enabled. If it is on, animations are disabled.
    ANI_SWITCH = 91
    
    #---------------------
    # Automatic Dashing
    #---------------------
    
    # This will affect what string data will appear for the toggling of
    # automatic dashing portion of the system menu.
    AUTO_DASH_TITLE = "Automatic Dash"
    AUTO_DASH_HELP  = "Toggles automatic dashing."
    AUTO_DASH_ON    = "Auto"
    AUTO_DASH_OFF   = "Hold"
    
    # This is the switch used to determine whether or not autodashing is on.
    AUTO_DASH_SWITCH = 95
    
    #---------------------
    # Instant Text
    #---------------------
    
    # This will affect what string data will appear for the instant text
    # portion of the system menu.
    INSTANT_TEXT_TITLE = "Instant Text"
    INSTANT_TEXT_HELP  = "Toggles instant text display."
    INSTANT_TEXT_ON    = "Instant"
    INSTANT_TEXT_OFF   = "Default"
    
    # This is the switch used to determine whether or not instant text is on.
    INSTANT_TEXT_SWITCH = 96
    
    #---------------------
    # Remaining Text
    #---------------------
    
    # This will affect what remaining string data is left for the system menu.
    RETURN_TO_TITLE   = "Return to Title Screen"
    RETURN_TITLE_HELP = "Return back to the title screen."
    RETURN_TO_MENU    = "Return to Main Menu"
    RETURN_MENU_HELP  = "Return back to the main menu."
      
  end # SYSTEM
end # YE

#===============================================================================
# Editting anything past this point may potentially result in causing computer
# damage, incontinence, explosion of user's head, coma, death, and/or halitosis.
# Therefore, edit at your own risk.
#===============================================================================

module Vocab
  def self.game_end
    return YE::SYSTEM::TITLE
  end
end

module Cache
  def self.windows(filename)
    load_bitmap("Graphics/Windows/", filename)
  end
end

module RPG
  
  class BGM < AudioFile
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGM_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
        end
        Audio.bgm_play("Audio/BGM/" + @name, vol, @pitch)
        @@last = self
      end
    end #Play
  end # BGM
  
  class ME < AudioFile
    def play
      if @name.empty?
        Audio.me_stop
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGM_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
        end
        Audio.me_play("Audio/ME/" + @name, vol, @pitch)
      end
    end
  end # ME
  
  class SE < AudioFile
    def play
      unless @name.empty?
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::SFX_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
        end
        Audio.se_play("Audio/SE/" + @name, vol, @pitch)
      end
    end
    def self.stop
      Audio.se_stop
    end
  end # SE
  
  class BGS < AudioFile
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGS_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
        end
        Audio.bgs_play("Audio/BGS/" + @name, vol, @pitch)
        @@last = self
      end
    end
  end # BGS
  
end # RPG

#===============================================================================
# Game Player
#===============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias dash?
  #--------------------------------------------------------------------------
  alias dash_mso dash? unless $@
  def dash?
    if $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH]
      return false if @move_route_forcing
      return false if $game_map.disable_dash?
      return false if in_vehicle?
      return false if Input.press?(Input::A)
      return true
    else
      dash_mso
    end
  end
  
end

#~ #===============================================================================
#~ # Window
#~ #===============================================================================

#~ class Window
#~   
#~   #--------------------------------------------------------------------------
#~   # update windowskin
#~   #--------------------------------------------------------------------------
#~   def update_windowskin
#~     if $game_variables != nil
#~       winvar = YE::SYSTEM::WINDOW_VARIABLE
#~       if $game_variables[winvar] == 0
#~         $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
#~       elsif !YE::SYSTEM::WINDOW_HASH.include?($game_variables[winvar])
#~         $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
#~       end
#~       mso_windowskin = YE::SYSTEM::WINDOW_HASH[$game_variables[winvar]]
#~     else
#~       mso_windowskin = YE::SYSTEM::WINDOW_HASH[YE::SYSTEM::DEFAULT_WINDOW]
#~     end
#~     self.windowskin = Cache.windows(mso_windowskin)
#~   end
#~   
#~ end

#~ #===============================================================================
#~ # Window Base
#~ #===============================================================================

#~ class Window_Base < Window
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_window_mso initialize unless $@
#~   def initialize(x, y, width, height)
#~     initialize_window_mso(x, y, width, height)
#~     self.update_windowskin
#~   end
#~   
#~ end

#===============================================================================
# Window Message
#===============================================================================

class Window_Message < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias update show fast
  #--------------------------------------------------------------------------
  alias update_show_fast_mso update_show_fast unless $@
  def update_show_fast
    if $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH]
      if self.pause or self.openness < 255
        @show_fast = false
      else
        @show_fast = true
      end
      if @show_fast and @wait_count > 0
        @wait_count -= 1
      end
    else
      update_show_fast_mso
    end
  end

#~ if $worale != nil
#~   if $worale["NMS"]
#~   #--------------------------------------------------------------------------
#~   # alias draw_name
#~   #--------------------------------------------------------------------------
#~   alias draw_name_mso draw_name unless $@
#~   def draw_name(name, x, y)
#~     draw_name_mso(name, x, y)
#~     @namebox.update_windowskin
#~   end
#~   end
#~ end
  
end
#~
#~ #===============================================================================
#~ # Window System
#~ #===============================================================================

#~ class Window_System < Window_Selectable
#~   
#~   #--------------------------------------------------------------------------
#~   # Initialize
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 56, 544, 360)
#~     @column_max = 1
#~     self.index = 0
#~     self.active = true
#~     refresh
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     @data = []
#~     @data.push(0) # Window Skins
#~     @data.push(1) # Sound Volume/Sound Mute
#~     @data.push(2) # BGM Volume/BGM Mute
#~     @data.push(3) # Ambience Volume/Ambience Mute
#~     @data.push(4) # Battle Animations
#~     @data.push(5) # Auto-Dash
#~     @data.push(6) # Instant Text
#~     @data.push(7) # Return to Title
#~     @data.push(8) # Return to Menu
#~     @item_max = @data.size
#~     self.contents.clear
#~     for i in 0..@item_max
#~       self.contents.font.color.alpha = 255
#~       draw_item(i)
#~     end
#~     #---
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Draw Item
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     sw = self.width - 32
#~     dw = sw
#~     #---
#~     case index
#~     when 0
#~       dx = 0
#~       dy = 0
#~       text = YE::SYSTEM::WINDOW_SKIN
#~       self.contents.draw_text(dx, dy, dw, WLH, text, 1)
#~       winvar = $game_variables[YE::SYSTEM::WINDOW_VARIABLE]
#~       text = YE::SYSTEM::WINDOW_HASH[winvar - 2]
#~       self.contents.draw_text(dx + dw * 0/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar - 1]
#~       self.contents.draw_text(dx + dw * 1/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar]
#~       self.contents.draw_text(dx + dw * 2/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar + 1]
#~       self.contents.draw_text(dx + dw * 3/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar + 2]
#~       self.contents.draw_text(dx + dw * 4/5, dy + WLH, dw/5, WLH, text, 1)
#~     when 1
#~       dx = 0
#~       dy = WLH * 2
#~       text = YE::SYSTEM::BGM_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 2
#~       dx = 0
#~       dy = WLH * 4
#~       text = YE::SYSTEM::SFX_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 3
#~       dx = 0
#~       dy = WLH * 6
#~       text = YE::SYSTEM::BGS_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 4
#~       dx = 0
#~       dy = WLH * 8
#~       text = YE::SYSTEM::ANI_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::ANI_SWITCH]
#~         en1 = false
#~         en2 = true
#~       else
#~         en1 = true
#~         en2 = false
#~       end
#~       text1 = YE::SYSTEM::ANI_ON
#~       text2 = YE::SYSTEM::ANI_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 5
#~       dx = 0
#~       dy = WLH * 9
#~       text = YE::SYSTEM::AUTO_DASH_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH]
#~         en1 = true
#~         en2 = false
#~       else
#~         en1 = false
#~         en2 = true
#~       end
#~       text1 = YE::SYSTEM::AUTO_DASH_ON
#~       text2 = YE::SYSTEM::AUTO_DASH_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 6
#~       dx = 0
#~       dy = WLH * 10
#~       text = YE::SYSTEM::INSTANT_TEXT_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH]
#~         en1 = true
#~         en2 = false
#~       else
#~         en1 = false
#~         en2 = true
#~       end
#~       text1 = YE::SYSTEM::INSTANT_TEXT_ON
#~       text2 = YE::SYSTEM::INSTANT_TEXT_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 7
#~       dx = 0
#~       dy = WLH * 11
#~       text = YE::SYSTEM::RETURN_TO_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw - 20, WLH, text, 0)
#~     #---
#~     when 8
#~       dx = 0
#~       dy = WLH * 12
#~       text = YE::SYSTEM::RETURN_TO_MENU
#~       self.contents.draw_text(dx + 20, dy, dw - 20, WLH, text, 0)
#~     end
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Update Cursor
#~   #--------------------------------------------------------------------------
#~   def update_cursor
#~     if @index < 0
#~       self.cursor_rect.empty
#~     elsif @index < 4
#~       self.cursor_rect.set(0, @index * 48, self.width - 32, 48)
#~     else
#~       self.cursor_rect.set(0, @index * 24 + 96, self.width - 32, 24)
#~     end
#~   end
#~   
#~ end

#~ #===============================================================================
#~ # Window Volume
#~ #===============================================================================

#~ class Window_Volume < Window_Base
#~   
#~   #--------------------------------------------------------------------------
#~   # initialize
#~   #--------------------------------------------------------------------------
#~   def initialize(wx, wy, ww, wh, var)
#~     super(wx, wy, ww, wh)
#~     @var = var
#~     if @var == YE::SYSTEM::BGM_VOLUME_VAR
#~       @gc1 = text_color(YE::SYSTEM::BGM_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::BGM_COLOUR2)
#~       @mute = YE::SYSTEM::BGM_MUTE_SWITCH
#~     elsif @var == YE::SYSTEM::SFX_VOLUME_VAR
#~       @gc1 = text_color(YE::SYSTEM::SFX_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::SFX_COLOUR2)
#~       @mute = YE::SYSTEM::SFX_MUTE_SWITCH
#~     else
#~       @gc1 = text_color(YE::SYSTEM::BGS_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::BGS_COLOUR2)
#~       @mute = YE::SYSTEM::BGS_MUTE_SWITCH
#~     end
#~     self.opacity = 0
#~     refresh
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     self.contents.clear
#~     sw = self.width - 32
#~     self.contents.fill_rect(0, 14, sw-80, 20, gauge_back_color)
#~     gw = sw-84
#~     gw *= 100 - $game_variables[@var]
#~     gw /= 100
#~     gw = [[gw, 0].max, sw-84].min
#~     self.contents.gradient_fill_rect(2, 16, gw, 16, @gc1, @gc2)
#~     if $game_switches[@mute]
#~       text = YE::SYSTEM::VOL_MUTE
#~     else
#~       text = sprintf("%d%%", 100 - $game_variables[@var])
#~     end
#~     self.contents.draw_text(sw-76, 0, 76, WLH*2, text, 0)
#~   end
#~   
#~ end
#~
#~ #===============================================================================
#~ # Modern Algebra ATS Compatibility
#~ #===============================================================================

#~ class Window_FaceBox < Window_Base
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_fb_mso initialize unless $@
#~   def initialize
#~     initialize_fb_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_NameBox < Window_Base
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_nb_mso initialize unless $@
#~   def initialize(string = '')
#~     initialize_nb_mso(string)
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_ChoiceBox < Window_Command 
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_cb_mso initialize unless $@
#~   def initialize
#~     initialize_cb_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_Message < Window_Selectable
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_wm_mso initialize unless $@
#~   def initialize
#~     initialize_wm_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#===============================================================================
# Scene_Battle
#===============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias display_normal_animation
  #--------------------------------------------------------------------------
  alias display_normal_animation_mso display_normal_animation unless $@
  def display_normal_animation(targets, animation_id, mirror = false)
    return if $game_switches[YE::SYSTEM::ANI_SWITCH]      
    display_normal_animation_mso(targets, animation_id, mirror)
  end
  
end

#~ #===============================================================================
#~ # Scene_End
#~ #===============================================================================

#~ class Scene_End < Scene_Base

#~   #--------------------------------------------------------------------------
#~   # Start processing
#~   #--------------------------------------------------------------------------
#~   def start
#~     super
#~     create_menu_background
#~     @help_window = Window_Base.new(0, 0, 544, 56)
#~     @help_window.contents.clear
#~     #---
#~     text = YE::SYSTEM::WINDOW_HELP
#~     @help_window.contents.draw_text(4,  0, 504, 24, text, 0)
#~     @system_window = Window_System.new
#~     var = YE::SYSTEM::BGM_VOLUME_VAR
#~     @bgm_vol_window = Window_Volume.new(160, 104, 384, 80, var)
#~     var = YE::SYSTEM::SFX_VOLUME_VAR
#~     @sfx_vol_window = Window_Volume.new(160, 152, 384, 80, var)
#~     var = YE::SYSTEM::BGS_VOLUME_VAR
#~     @bgs_vol_window = Window_Volume.new(160, 200, 384, 80, var)
#~     #---
#~     @last_index = 100
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Post-Start Processing
#~   #--------------------------------------------------------------------------
#~   def post_start
#~     super
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Pre-termination Processing
#~   #--------------------------------------------------------------------------
#~   def pre_terminate
#~     super
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Termination Processing
#~   #--------------------------------------------------------------------------
#~   def terminate
#~     super
#~     @help_window.dispose
#~     @system_window.dispose
#~     @bgm_vol_window.dispose
#~     @sfx_vol_window.dispose
#~     @bgs_vol_window.dispose
#~     dispose_menu_background
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Update Help
#~   #--------------------------------------------------------------------------
#~   def update_help
#~     @help_window.contents.clear
#~     case @system_window.index
#~     when 0; text = YE::SYSTEM::WINDOW_HELP
#~     when 1; text = YE::SYSTEM::BGM_HELP
#~     when 2; text = YE::SYSTEM::SFX_HELP
#~     when 3; text = YE::SYSTEM::BGS_HELP
#~     when 4; text = YE::SYSTEM::ANI_HELP
#~     when 5; text = YE::SYSTEM::AUTO_DASH_HELP
#~     when 6; text = YE::SYSTEM::INSTANT_TEXT_HELP
#~     when 7; text = YE::SYSTEM::RETURN_TITLE_HELP
#~     when 8; text = YE::SYSTEM::RETURN_MENU_HELP
#~     end
#~     @help_window.contents.draw_text(4,  0, 504, 24, text, 0)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Frame Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     update_menu_background
#~     @system_window.update
#~     
#~     if @last_index != @system_window.index
#~       @last_index = @system_window.index
#~       update_help
#~     end
#~     
#~     if Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       return_scene
#~     else
#~       #---
#~       if Input.repeat?(Input::LEFT) and @system_window.index == 0
#~         $game_variables[YE::SYSTEM::WINDOW_VARIABLE] -= 1
#~         if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] == 0
#~           $game_variables[YE::SYSTEM::WINDOW_VARIABLE] = 1
#~         else
#~           Sound.play_cursor
#~         end
#~         @system_window.refresh
#~         @system_window.update_windowskin
#~         @help_window.update_windowskin
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 0
#~         $game_variables[YE::SYSTEM::WINDOW_VARIABLE] += 1
#~         if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] >
#~         YE::SYSTEM::WINDOW_HASH.size
#~           $game_variables[YE::SYSTEM::WINDOW_VARIABLE] =
#~           YE::SYSTEM::WINDOW_HASH.size
#~         else
#~           Sound.play_cursor
#~         end
#~         @system_window.refresh
#~         @system_window.update_windowskin
#~         @help_window.update_windowskin
#~       #---
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 1
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 1
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::L) and @system_window.index == 1
#~         if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::R) and @system_window.index == 1
#~         if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 2
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @sfx_vol_window.refresh
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 2
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @sfx_vol_window.refresh
#~       elsif Input.trigger?(Input::L) and @system_window.index == 2
#~         if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @sfx_vol_window.refresh
#~       elsif Input.trigger?(Input::R) and @system_window.index == 2
#~         if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @sfx_vol_window.refresh
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 3
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 3
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::L) and @system_window.index == 3
#~         if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::R) and @system_window.index == 3
#~         if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 4
#~         $game_switches[YE::SYSTEM::ANI_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 4
#~         $game_switches[YE::SYSTEM::ANI_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 5
#~         $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 5
#~         $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 6
#~         $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 6
#~         $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::C) and @system_window.index == 7
#~         Sound.play_decision
#~         RPG::BGM.fade(800)
#~         RPG::BGS.fade(800)
#~         RPG::ME.fade(800)
#~         $scene = Scene_Title.new
#~         Graphics.fadeout(60)
#~       elsif Input.trigger?(Input::C) and @system_window.index == 8
#~         Sound.play_cancel
#~         return_scene
#~       end
#~       #---
#~     end
#~   end
#~   
#~ end
#~
#===============================================================================
#
# END OF FILE
#
#===============================================================================