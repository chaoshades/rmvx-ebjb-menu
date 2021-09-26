#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
#_/           ◆         Plot Summary - KGC_Outline         ◆
#_/           ◇          Last Update: 2008/07/27           ◇
#_/           ◆   Translated and Ported by Mr. Anonymous   ◆
#_/-----------------------------------------------------------------------------
#_/  Provides the function to show "Outline".
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_

#==============================================================================#
#                             ★ Customization ★                                #
#==============================================================================#

module KGC
  module Outline
  #               ◆ Plot Summary Background Transparancy ◆
  OLINE_BACK_TRANSPARENT = false
  #                           ◆ Scroll Speed ◆
  OLINE_SCROLL_SPEED = 8

  #                   ◆ Draw A Serial Number Toggle ◆
  OLINE_SERIAL_NUMBER = false
  #                     ◆ Serial Number of Digits ◆
  OLINE_SERIAL_NUMBER_DIGITS = 3

  #                 ◆ Disabled Plot Summary Title Text ◆
  OLINE_DISABLED_TITLE = " - - - - - - - - "
  #                 ◆ Hide Disabled Plot Summary Toggle ◆
  OLINE_HIDE_DISABLED  = true

  #                   ◆ Completed Plot Summary Symbol ◆
  OLINE_COMPLETION_SYMBOL   = "*"
  #                   ◆ Incomplete Plot Summary Symbol ◆
  OLINE_INCOMPLETION_SYMBOL = "　"
  #            ◆ Outline Command for Main Command Menu Toggle ◆
  USE_MENU_OUTLINE_COMMAND = false
   #                  ◆ Outline Command Selection Text ◆
  VOCAB_MENU_OUTLINE = "Outline"
  
#~ #### OLINE_CONTENTS
#~ ### Contents of "Outline".
#~ #  << ["Title", ["Body", ...]], ... >>
#~ #  In the "Body", each line of the array creates one line in-game. 
#~ #    **** Control statement ****
#~ #  \\V[n]  : Variable of ID:n
#~ #  \\G     : Money
#~ #  \\N[n]  : Actor's name of ID:n
#~ #  \\EN[n] : Enemies' name of ID:n
#~ #  \\IN[n] : Item's name of ID:n
#~ #  \\WN[n] : Weapon's name of ID:n
#~ #  \\AN[n] : Armor's name of ID:n

#~   OLINE_CONTENTS = [
#~     ["Skills Menu Controls",  # No.0
#~       ["Here, I'll explain how to access certain menus:",
#~       "",
#~       "To access the Skill CP System window from the Skills Menu:",
#~       "Press the Z Button (V on Keyboard)",
#~       "Pressing Z again will take you to the EquipLearnSkill window.",
#~       "To return to the skills window, press Y (C on Keyboard)",
#~       "",
#~       "To access the EquipLearnSkill window from the Skills Menu:",
#~       "Press the Y Button.",
#~       "Pressing Y again will take you to the Skill CP System window.",
#~       "To return to the skills window, press Z.",
#~       "",
#~       "While in any of these menus, you can also use the L and R" +
#~       " buttons (Q and W on keyboard) to shift to the previous/next" +
#~       " actor.",]],
#~     ["To Acess DistributeParameter...", # No.1
#~       ["While on an actor's status screen, press the X Button (A on" +
#~        "the keyboard).",]],
#~   ]  # -- Don't delete this line! --
  end
end

#================================End Module====================================#

$imported = {} if $imported == nil
$imported["Outline"] = true

#==============================================================================
# ■ Module - KGC_Outline
#==============================================================================

module KGC::Commands
  module_function
  #--------------------------------------------------------------------------
  # ● Plot Summary Scene Calls
  #--------------------------------------------------------------------------
  def call_outline
    # Correct Player Position
    $game_player.straighten
    # Plot Summary Scene Call Script Method
    $scene = Scene_Outline.new(true)
  end
  #--------------------------------------------------------------------------
  # ● Plot Summary Enablement
  #     index : Plot Summary Number
  #     value : Enabled State (true | false)
  #--------------------------------------------------------------------------
  def set_outline_enabled(index, value = true)
    if $game_system.outline_enable == nil
      $game_system.outline_enable = []
    end
    $game_system.outline_enable[index] = value
  end
  #--------------------------------------------------------------------------
  # ● Completed Plot Summary
  #     index : Plot Summary Number
  #     value : Complete State (true | false)
  #--------------------------------------------------------------------------
  def set_outline_completed(index, value = true)
    if $game_system.outline_complete == nil
      $game_system.outline_complete = []
    end
    $game_system.outline_complete[index] = value
  end
#~   #--------------------------------------------------------------------------
#~   # ● Process Command Control
#~   #     string : A Processing String
#~   #--------------------------------------------------------------------------
#~   def apply_outline_control_statement(string)
#~     buf = string.dup
#~     buf.gsub!(/\\V\[(\d+)\]/i)  { $game_variables[$1.to_i].to_s }
#~     buf.gsub!(/\\G/i)           { $game_party.gold.to_s }
#~     buf.gsub!(/\\N\[(\d+)\]/i)  { $game_actors[$1.to_i].name }
#~     buf.gsub!(/\\EN\[(\d+)\]/i) { $data_enemies[$1.to_i].name }
#~     buf.gsub!(/\\IN\[(\d+)\]/i) { $data_items[$1.to_i].name }
#~     buf.gsub!(/\\WN\[(\d+)\]/i) { $data_weapons[$1.to_i].name }
#~     buf.gsub!(/\\AN\[(\d+)\]/i) { $data_armors[$1.to_i].name }
#~     return buf
#~   end
end

#=================================End Module===================================#

class Game_Interpreter
  include KGC::Commands
end

#==================================End Class===================================#

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  # Set new vocabulary for Outline
  def self.outline
    return KGC::Outline::VOCAB_MENU_OUTLINE
  end
end

#=================================End Module===================================#

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  attr_accessor :outline_enable, :outline_complete
  #--------------------------------------------------------------------------
  # ● Object initialization 
  #--------------------------------------------------------------------------
  alias initialize_KGC_Outline initialize
  def initialize
    initialize_KGC_Outline

    @outline_enable = []
    @outline_complete = []
  end
end

#==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_OutlineList
#~ #------------------------------------------------------------------------------
#~ # Plot Summary List Display Window
#~ #==============================================================================

#~ class Window_OutlineList < Window_Selectable
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(72, 16, 382, 382)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     self.index = 0
#~     self.z = 1000
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Selected Plot Contents
#~   #--------------------------------------------------------------------------
#~   def outline
#~     return @data[self.index]
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     self.contents.dispose if self.contents != nil
#~     @data = []
#~     @data_index = []
#~     # Lists
#~     $game_system.outline_enable = [] if $game_system.outline_enable == nil
#~     $game_system.outline_complete = [] if $game_system.outline_complete == nil
#~     KGC::Outline::OLINE_CONTENTS.each_with_index { |oline, i|
#~       if $game_system.outline_enable[i]
#~         @data << OutlineList_Info.new(oline[0], oline[1], i)
#~       elsif !KGC::Outline::OLINE_HIDE_DISABLED
#~         @data << OutlineList_Info.new(KGC::Outline::OLINE_DISABLED_TITLE, nil, i)
#~       end
#~     }
#~     # Draw List
#~     @item_max = [@data.size, 1].max
#~     self.contents = Bitmap.new(self.width - 32, 32 * @item_max)
#~     if @data.size == 0
#~       @data << OutlineList_Info.new
#~     else
#~       @data.each_index { |i| draw_item(i) }
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Draw Items
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     self.contents.fill_rect(0, 32 * index, self.width - 32, 32, Color.new(0, 0, 0, 0))
#~     # Generate Title
#~     text = ($game_system.outline_complete[@data[index].index] ?
#~       KGC::Outline::OLINE_COMPLETION_SYMBOL : KGC::Outline::OLINE_INCOMPLETION_SYMBOL) +
#~       (KGC::Outline::OLINE_SERIAL_NUMBER ? sprintf("%0*d : ",
#~       KGC::Outline::OLINE_SERIAL_NUMBER_DIGITS, @data[index].index + 1) : "") +
#~       KGC::Commands.apply_outline_control_statement(@data[index].title)
#~     # Set Color
#~     self.contents.font.color = $game_system.outline_enable[@data[index].index] ?
#~       normal_color : normal_color
#~     self.contents.draw_text(0, 24 * index, self.width - 32, 22, text)
#~   end
#~ end

#==============================================================================
# ■ OutlineList_Info
#------------------------------------------------------------------------------
#  Class to hold Plot Summary List Information
#==============================================================================

class OutlineList_Info
  attr_accessor :title, :contents, :index
  #--------------------------------------------------------------------------
  # ● Object initialization
  #--------------------------------------------------------------------------
  def initialize(title = "", contents = nil, index = 0)
    @title = title
    @contents = contents
    @index = index
  end
end

#==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_OutlineTitle
#~ #------------------------------------------------------------------------------
#~ # Plot Summary Title Window Display
#~ #==============================================================================

#~ class Window_OutlineTitle < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 0, 544, 64)
#~     self.contents = Bitmap.new(width - 32, height - 32)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #     text  : Visible Strings
#~   #--------------------------------------------------------------------------
#~   def refresh(text)
#~     self.contents.clear
#~     text2 = KGC::Commands::apply_outline_control_statement(text)
#~     self.contents.draw_text(0, 0, self.width - 32, 32, text2, 1)
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_Outline
#~ #------------------------------------------------------------------------------
#~ # 　 Plot (content) to display window.
#~ #==============================================================================

#~ class Window_Outline < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 64, 544, 352)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     self.active = false
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #     oline : Plot
#~   #--------------------------------------------------------------------------
#~   def refresh(oline = nil)
#~     self.oy = 0
#~     self.contents.dispose if self.contents != nil
#~     return if oline == nil
#~     # Draw Text 
#~     self.contents = Bitmap.new(self.width - 32, 32 * oline.size)
#~     oline.each_with_index { |l ,i|
#~       next if l == nil
#~       text = KGC::Commands::apply_outline_control_statement(l)
#~       self.contents.draw_text(0, i * 32, self.width - 32, 32, text)
#~     }
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     # Scroll
#~     if self.active
#~       scroll_max = [self.contents.height - (self.height - 32), 0].max
#~       if Input.press?(Input::UP)
#~         self.oy = [self.oy - KGC::Outline::OLINE_SCROLL_SPEED, 0].max
#~       elsif Input.press?(Input::DOWN)
#~         self.oy = [self.oy + KGC::Outline::OLINE_SCROLL_SPEED, scroll_max].min
#~       elsif Input.repeat?(Input::L)
#~         self.oy = [self.oy - (self.height - 32), 0].max
#~       elsif Input.repeat?(Input::R)
#~         self.oy = [self.oy + (self.height - 32), scroll_max].min
#~       end
#~     end
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Scene_Outline
#~ #------------------------------------------------------------------------------
#~ # Plot Summary Scene Class  
#~ #==============================================================================

#~ class Scene_Outline
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #     map_call : Map call flag
#~   #--------------------------------------------------------------------------
#~   def initialize(map_call = false)
#~     @map_call = map_call
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Main Process
#~   #--------------------------------------------------------------------------
#~   def main
#~     # Screate Spriteset
#~     @spriteset = Spriteset_Map.new if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     # Create Window
#~     @list_window = Window_OutlineList.new
#~     @title_window = Window_OutlineTitle.new
#~     @content_window = Window_Outline.new
#~     # Run Transition
#~     Graphics.transition
#~     # Loop Main
#~     loop {
#~       Graphics.update
#~       Input.update
#~       update
#~       if $scene != self
#~         break
#~       end
#~     }
#~     # Freeze Graphics
#~     Graphics.freeze
#~     # Dispose
#~     @list_window.dispose
#~     @title_window.dispose
#~     @content_window.dispose
#~     @spriteset.dispose if KGC::Outline::OLINE_BACK_TRANSPARENT
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     # Update Windows
#~     @list_window.update
#~     @title_window.update
#~     @content_window.update
#~     # Operate Active Window
#~     if @list_window.active
#~       update_list
#~     elsif @content_window.active
#~       update_content
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update Frame (List)
#~   #--------------------------------------------------------------------------
#~   def update_list
#~     # If B Button is Pressed 
#~     if Input.trigger?(Input::B)
#~       # Play cancel SE
#~       $data_system.sounds[2].play
#~       if @map_call
#~         # Call Map
#~         $scene = Scene_Map.new
#~       else
#~           $scene = Scene_Menu.new
#~       end
#~       return
#~     end
#~     # If C Button is Pressed 
#~     if Input.trigger?(Input::C)
#~       outline = @list_window.outline
#~       # If you cannot view...
#~       if outline.contents == nil
#~         # Play buzzer SE
#~         $data_system.sounds[3].play
#~         return
#~       end
#~       # Play decision SE
#~       $data_system.sounds[1].play
#~       # Update Plot Summary 
#~       @title_window.refresh(outline.title)
#~       @content_window.refresh(outline.contents)
#~       # Switch Window
#~       @list_window.active = false
#~       @list_window.z = 0
#~       @content_window.active = true
#~       @content_window.z = 1000
#~       return
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Frame Update (Text)
#~   #--------------------------------------------------------------------------
#~   def update_content
#~     # If B Button is Pressed 
#~     if Input.trigger?(Input::B)
#~       # Play cancel SE
#~       $data_system.sounds[2].play
#~       # Switch Window
#~       @list_window.active = true
#~       @list_window.z = 1000
#~       @content_window.active = false
#~       @content_window.z = 0
#~       return
#~     end
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Scene_Menu
#~ #==============================================================================

#~ class Scene_Menu < Scene_Base
#~   if KGC::Outline::USE_MENU_OUTLINE_COMMAND
#~   #--------------------------------------------------------------------------
#~   # ● Create command window
#~   #--------------------------------------------------------------------------
#~     alias create_command_window_KGC_Outline create_command_window
#~     def create_command_window
#~       create_command_window_KGC_Outline

#~       return if $imported["CustomMenuCommand"]

#~       @__command_outline_index =
#~         @command_window.add_command(Vocab.outline)
#~       @command_window.draw_item(@__command_outline_index)
#~       if @command_window.oy > 0
#~         @command_window.oy -= Window_Base::WLH
#~       end
#~       @command_window.index = @menu_index
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update Command Selection
#~   #--------------------------------------------------------------------------
#~   alias update_command_selection_KGC_Outline update_command_selection
#~   def update_command_selection
#~     current_menu_index = @__command_outline_index
#~     call_outline_flag = false

#~     if Input.trigger?(Input::C)
#~       case @command_window.index
#~       when @__command_outline_index 
#~         call_outline_flag = true
#~       end
#~     end
#~     if call_outline_flag
#~       Sound.play_decision
#~       $scene = Scene_Outline.new(current_menu_index)
#~       return
#~     end

#~     update_command_selection_KGC_Outline
#~   end
#~ end

#~ #==================================End Class===================================#