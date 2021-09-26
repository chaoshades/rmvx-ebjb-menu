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
