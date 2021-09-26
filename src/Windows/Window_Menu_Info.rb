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