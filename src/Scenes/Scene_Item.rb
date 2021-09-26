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
