#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆         Battle Difficulty - KGC_BattleDifficulty        ◆ VX ◆
#_/    ◇                 Last Update: 2008/05/09                      ◇
#_/    ◆               Translation by Mr. Anonymous                   ◆
#_/----------------------------------------------------------------------------
#_/  This script adds battle difficulty settings to your game.
#_/============================================================================
#_/  Installation: Insert below KGC_ExtraDropItem and KGC_CustomMenuCommand.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================#
#                            ★ Customization ★                                 #
#==============================================================================#

module KGC
module BattleDifficulty
  #                       ◆ Difficulty Variable ◆
  #  Change the variable the difficulty setting is stored in.
  DIFFICULTY_VARIABLE = 15

  #                           ◆ Difficulty ◆
  #  Difficulty Format:
  #   DIFFICULTY << {
  #     :name  => "Difficulty Name",
  #     :maxhp => MaxHP,
  #     :maxmp => MaxMP,
  #     :atk   => Attack,
  #     :def   => Defense,
  #     :spi   => Spirit,
  #     :agi   => Agility,
  #     :param => Attack ・ Defense ・ Spirit ・ Agility (Batch Specification),
  #     :hit   => Hit Ratio,
  #     :eva   => Evasion,
  #     :cri   => Critical,
  #     :exp   => Experience,
  #     :gold  => Gold,
  #     :drop  => Item Drop Rate,
  #   }
  #  Create by the format
  #  （:atk, :def, :spi, :agi (The :param field takes highest priority）
  #  The unit is a percentile of a each item.
  #  :name is not optional
  #  An omitted item is treated as a default of 100
  DIFFICULTY = [] # Do not remove or modify this line!
  # ～ Custom Difficulty Settings Inserted Below Here ～
  DIFFICULTY << {        # Difficulty Level: 0
    :name  => "Easy",
    :maxhp => 80,
    :maxmp => 80,
    :param => 80,
    :cri   => 50,
    :drop  => 90,
  }  # ← Do not remove!
  DIFFICULTY << {        # Difficulty Level: 1
    :name  => "Normal",
  }
  DIFFICULTY << {        # Difficulty Level: 2
    :name  => "Hard",
    :maxhp => 150,
    :maxmp => 130,
    :atk   => 120,
    :spi   => 120,
    :agi   => 110,
    :drop  => 120,
  }
  DIFFICULTY << {        # Difficulty Level: 3
    :name  => "Very Hard",
    :maxhp => 200,
    :maxmp => 180,
    :atk   => 150,
    :spi   => 150,
    :agi   => 130,
    :cri   => 120,
    :drop  => 140,
  }
  DIFFICULTY << {        # Difficulty Level: 4
    :name  => "Extreme",
    :maxhp => 300,
    :maxmp => 260,
    :atk   => 200,
    :spi   => 200,
    :agi   => 150,
    :cri   => 160,
    :drop  => 160,
  }
  DIFFICULTY << {        # Difficulty Level: 5
    :name  => "Legendary",
    :maxhp => 500,
    :maxmp => 400,
    :atk   => 300,
    :spi   => 300,
    :agi   => 180,
    :cri   => 200,
    :drop  => 200,
  }

  #                      ◆ Difficulty Initialization ◆
  #  DIFFICULTY Index
  #  By default, 1 = Normal
  INITIAL_DIFFICULTY = 1

  #                 ◆ Add Difficulty Command to Main Menu ◆
  #  This toggle enables/disables the difficulty command selection to be added 
  #   to the main command menu.
  USE_MENU_DIFFICULTY_COMMAND = false
end
end

#------------------------------------------------------------------------------#

$imported = {} if $imported == nil
$imported["BattleDifficulty"] = true

module KGC::BattleDifficulty
  # Parameters
  PARAMS = [
    :maxhp, :maxmp, :atk, :def, :spi, :agi,
    :hit, :eva, :cri, :exp, :gold, :drop
  ]

  module_function
  #--------------------------------------------------------------------------
  # ○ 難易度補正値作成
  #--------------------------------------------------------------------------
  def create_param_revs
    @@param_revs = []
    DIFFICULTY.each { |d|
      rev = {}
      rev[:name] = d[:name]
      # 一括指定を適用
      if d[:param] != nil
        rev[:atk] = rev[:def] = rev[:spi] = rev[:agi] = d[:param]
      end
      # パラメータ指定を適用
      PARAMS.each { |par|
        if d[par] != nil
          rev[par] = d[par]
        else
          rev[par] = 100 if rev[par] == nil
        end
      }
      # リストに追加
      @@param_revs << rev
    }
  end
  #--------------------------------------------------------------------------
  # ○ 難易度補正値取得
  #--------------------------------------------------------------------------
  def param_revs
    return @@param_revs
  end
  #--------------------------------------------------------------------------
  # ○ 難易度インデックス取得
  #--------------------------------------------------------------------------
  def get_index
    vid = DIFFICULTY_VARIABLE
    if $game_variables[vid] < 0 || DIFFICULTY.size <= $game_variables[vid]
      $game_variables[vid] = INITIAL_DIFFICULTY
    end
    return $game_variables[vid]
  end
  #--------------------------------------------------------------------------
  # ○ 難易度取得
  #--------------------------------------------------------------------------
  def get
    return @@param_revs[get_index]
  end
  #--------------------------------------------------------------------------
  # ○ 難易度変更
  #     index : 難易度インデックス
  #--------------------------------------------------------------------------
  def set(index)
    index = [[index, DIFFICULTY.size - 1].min, 0].max
    $game_variables[DIFFICULTY_VARIABLE] = index
  end

  create_param_revs
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Enemy::DropItem
#==============================================================================

unless $@
class RPG::Enemy::DropItem
  #--------------------------------------------------------------------------
  # ● 出現率 1/N の分母 N
  #--------------------------------------------------------------------------
  alias denominator_KGC_BattleDifficulty denominator
  def denominator
    n = denominator_KGC_BattleDifficulty
    if n > 1
      n = [n * 100 / KGC::BattleDifficulty.get[:drop], 1].max
    end
    return n
  end

if method_defined?(:drop_prob)
  #--------------------------------------------------------------------------
  # ○ ドロップ率 (直接指定)
  #--------------------------------------------------------------------------
  alias drop_prob_KGC_BattleDifficulty drop_prob
  def drop_prob
    n = drop_prob_KGC_BattleDifficulty
    if n < 100 && 0 < n
      n = [[n * KGC::BattleDifficulty.get[:drop] / 100, 1].max, 100].min
    end
    return n
  end
end

end  # class
end  # unless $@

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 基本 MaxHP の取得
  #--------------------------------------------------------------------------
  alias base_maxhp_KGC_BattleDifficulty base_maxhp
  def base_maxhp
    n = base_maxhp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:maxhp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxMP の取得
  #--------------------------------------------------------------------------
  alias base_maxmp_KGC_BattleDifficulty base_maxmp
  def base_maxmp
    n = base_maxmp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:maxmp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本攻撃力の取得
  #--------------------------------------------------------------------------
  alias base_atk_KGC_BattleDifficulty base_atk
  def base_atk
    n = base_atk_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:atk] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本防御力の取得
  #--------------------------------------------------------------------------
  alias base_def_KGC_BattleDifficulty base_def
  def base_def
    n = base_def_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:def] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本精神力の取得
  #--------------------------------------------------------------------------
  alias base_spi_KGC_BattleDifficulty base_spi
  def base_spi
    n = base_spi_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:spi] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本敏捷性の取得
  #--------------------------------------------------------------------------
  alias base_agi_KGC_BattleDifficulty base_agi
  def base_agi
    n = base_agi_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:agi] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  alias hit_KGC_BattleDifficulty hit
  def hit
    n = hit_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:hit] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 回避率の取得
  #--------------------------------------------------------------------------
  alias eva_KGC_BattleDifficulty eva
  def eva
    n = eva_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:eva] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias cri_KGC_BattleDifficulty cri
  def cri
    n = cri_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:cri] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 経験値の取得
  #--------------------------------------------------------------------------
  alias exp_KGC_BattleDifficulty exp
  def exp
    n = exp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:exp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● お金の取得
  #--------------------------------------------------------------------------
  alias gold_KGC_BattleDifficulty gold
  def gold
    n = gold_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:gold] / 100
    return n
  end
end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#~ #==============================================================================
#~ # ■ Window_Command
#~ #==============================================================================

#~ class Window_Command < Window_Selectable

#~ unless method_defined?(:add_command)
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを追加
#~   #    追加した位置を返す
#~   #--------------------------------------------------------------------------
#~   def add_command(command)
#~     @commands << command
#~     @item_max = @commands.size
#~     item_index = @item_max - 1
#~     refresh_command
#~     draw_item(item_index)
#~     return item_index
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドをリフレッシュ
#~   #--------------------------------------------------------------------------
#~   def refresh_command
#~     buf = self.contents.clone
#~     self.height = [self.height, row_max * WLH + 32].max
#~     create_contents
#~     self.contents.blt(0, 0, buf, buf.rect)
#~     buf.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを挿入
#~   #--------------------------------------------------------------------------
#~   def insert_command(index, command)
#~     @commands.insert(index, command)
#~     @item_max = @commands.size
#~     refresh_command
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを削除
#~   #--------------------------------------------------------------------------
#~   def remove_command(command)
#~     @commands.delete(command)
#~     @item_max = @commands.size
#~     refresh
#~   end
#~ end

#~ unless method_defined?(:replace_command)
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを置換
#~   #--------------------------------------------------------------------------
#~   def replace_command(index, command, enabled = true)
#~     @commands[index] = command
#~     draw_item(index, enabled)
#~   end
#~ end

#~ end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias create_game_objects_KGC_BattleDifficulty create_game_objects
  def create_game_objects
    create_game_objects_KGC_BattleDifficulty

    # 難易度を初期化
    variable_id = KGC::BattleDifficulty::DIFFICULTY_VARIABLE
    $game_variables[variable_id] = KGC::BattleDifficulty::INITIAL_DIFFICULTY
  end
end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#~ #==============================================================================
#~ # ■ Scene_Menu
#~ #==============================================================================

#~ class Scene_Menu < Scene_Base
#~   #--------------------------------------------------------------------------
#~   # ● コマンドウィンドウの作成
#~   #--------------------------------------------------------------------------
#~   alias create_command_window_KGC_BattleDifficulty create_command_window
#~   def create_command_window
#~     create_command_window_KGC_BattleDifficulty

#~     create_difficulty_window

#~     return unless KGC::BattleDifficulty::USE_MENU_DIFFICULTY_COMMAND
#~     return if $imported["CustomMenuCommand"]

#~     @__command_set_difficulty_index =
#~       @command_window.add_command(KGC::BattleDifficulty.get[:name])
#~     if @command_window.oy > 0
#~       @command_window.oy -= Window_Base::WLH
#~     end
#~     @command_window.index = @menu_index
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択ウィンドウの作成
#~   #--------------------------------------------------------------------------
#~   def create_difficulty_window
#~     commands = []
#~     KGC::BattleDifficulty::param_revs.each { |d|
#~       commands << d[:name]
#~     }
#~     @difficulty_window = Window_Command.new(160, commands)
#~     @difficulty_window.x = @command_window.width - 16
#~     @difficulty_window.z = 1000
#~     @difficulty_window.active = false
#~     @difficulty_window.openness = 0
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 終了処理
#~   #--------------------------------------------------------------------------
#~   alias terminate_KGC_BattleDifficulty terminate
#~   def terminate
#~     terminate_KGC_BattleDifficulty

#~     @difficulty_window.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● フレーム更新
#~   #--------------------------------------------------------------------------
#~   alias update_KGC_BattleDifficulty update
#~   def update
#~     @difficulty_window.update
#~     if @difficulty_window.active
#~       update_KGC_BattleDifficulty

#~       update_difficulty_selection
#~       return
#~     end

#~     update_KGC_BattleDifficulty
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンド選択の更新
#~   #--------------------------------------------------------------------------
#~   alias update_command_selection_KGC_BattleDifficulty update_command_selection
#~   def update_command_selection
#~     call_ap_viewer_flag = false
#~     if Input.trigger?(Input::C)
#~       case @command_window.index
#~       when @__command_set_difficulty_index  # 難易度設定
#~         call_set_difficulty_flag = true
#~       end
#~     end

#~     # 難易度設定に移行
#~     if call_set_difficulty_flag
#~       Sound.play_decision
#~       start_difficulty_selection
#~       return
#~     end

#~     update_command_selection_KGC_BattleDifficulty
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の開始
#~   #--------------------------------------------------------------------------
#~   def start_difficulty_selection
#~     @command_window.active = false
#~     dy = @command_window.cursor_rect.y
#~     limit_y = Graphics.height - @difficulty_window.height
#~     @difficulty_window.y = [[dy, limit_y].min, 0].max
#~     @difficulty_window.active = true
#~     @difficulty_window.index = KGC::BattleDifficulty.get_index
#~     @difficulty_window.open
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の終了
#~   #--------------------------------------------------------------------------
#~   def end_difficulty_selection
#~     @command_window.active = true
#~     @difficulty_window.active = false
#~     @difficulty_window.close
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の更新
#~   #--------------------------------------------------------------------------
#~   def update_difficulty_selection
#~     if Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       end_difficulty_selection
#~     elsif Input.trigger?(Input::C)
#~       Sound.play_decision
#~       # 難易度を変更
#~       KGC::BattleDifficulty.set(@difficulty_window.index)
#~       @command_window.replace_command(@__command_set_difficulty_index,
#~         KGC::BattleDifficulty.get[:name])
#~       end_difficulty_selection
#~     end
#~   end
#~ end
