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