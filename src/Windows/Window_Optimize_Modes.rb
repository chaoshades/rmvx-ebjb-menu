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
