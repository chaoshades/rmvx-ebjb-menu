#==============================================================================
# ** UCVolumeControl
#------------------------------------------------------------------------------
#  Represents a group of controls to control volume
#==============================================================================

class UCVolumeControl < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the volume label
  attr_reader :cVolumeLabel
  # Label for the mute message
  attr_reader :cMuteLabel
  # UCBar for the volume gauge
  attr_reader :ucVolumeBar
  # Label for the volume value
  attr_reader :cVolumeValue
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cVolumeLabel.visible = visible
    @cMuteLabel.visible = visible
    @ucVolumeBar.visible = visible
    @cVolumeValue.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cVolumeLabel.active = active
    @cMuteLabel.active = active
    @ucVolumeBar.active = active
    @cVolumeValue.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the user control will appear
  #     rect : rectangle to position the controls for the volume
  #     volumeLabel : Label for the label in the Label control for the volume
  #     bar_color1 : Color 1 of the volume bar
  #     bar_color2 : Color 2 of the volume bar (used for gradient)
  #     bar_back_color : Color of the background of the volume bar
  #     bar_border : volume bar border width
  #     bar_border_color : Color of the border of the volume bar
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, rect, volumeLabel, bar_color1, bar_color2, bar_back_color,
                 bar_border, bar_border_color,
                 active=true, visible=true)
    super(active, visible)
    
    # Determine rectangles to position controls
    rects = determine_rects(rect)
    
    @cVolumeLabel = CLabel.new(window, rects[0], volumeLabel, 0, Font.bold_font)
    @cVolumeLabel.active = active
    @cVolumeLabel.visible = visible
    
    @ucVolumeBar = UCBar.new(window, rects[1], bar_color1, bar_color2,
                             bar_back_color, 0, 100, bar_border, bar_border_color)
    @ucVolumeBar.active = active
    @ucVolumeBar.visible = visible
    
    @cMuteLabel = CLabel.new(window, rects[2], Vocab::system_mute_volume_label, 1)
    @cMuteLabel.active = active
    @cMuteLabel.visible = visible
    
    @cVolumeValue = CLabel.new(window, rects[3], 0, 1)
    @cVolumeValue.active = active
    @cVolumeValue.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     mute : true to mute the volume, else false
  #     volume : volume value
  #--------------------------------------------------------------------------
  def update(mute, volume)
    if mute
      vol = 0
      @cMuteLabel.visible = true
      @cVolumeValue.visible = false
    else
      vol = 100 - volume
      @cMuteLabel.visible = false
      @cVolumeValue.visible = true
    end
    @cVolumeValue.text = sprintf(MENU_CONFIG::VOL_PATTERN, vol)
    @ucVolumeBar.value = vol
  end
  
  #--------------------------------------------------------------------------
  # * Draw the controls
  #--------------------------------------------------------------------------
  def draw()
    @cVolumeLabel.draw()
    @ucVolumeBar.draw()
    @cMuteLabel.draw()
    @cVolumeValue.draw()
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Determine rectangles to positions controls in the user control
  #     rect : base rectangle to position the controls
  #--------------------------------------------------------------------------
  def determine_rects(rect)
    rects = []
    
    # Rects Initialization
    rects[0] = Rect.new(rect.x,rect.y,rect.width,24)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,20)
    rects[2] = Rect.new(rect.x,rect.y,rect.width,20)
    rects[3] = Rect.new(rect.x,rect.y,rect.width,20)
    
    # Rects Adjustments
    
    # cVolumeLabel
    rects[0].width = (rect.width/3).floor
    
    # ucVolumeBar
    rects[1].x += rects[0].width
    rects[1].y += ((rect.height - rects[1].height)/2).floor
    rects[1].width -= rects[0].width
    
    # cMuteLabel
    rects[2].x += rects[0].width
    rects[2].y = rects[1].y
    rects[2].width = rects[1].width
      
    # cVolumeValue
    rects[3].x += rects[0].width
    rects[3].y = rects[1].y
    rects[3].width = rects[1].width
    
    return rects
  end
  private :determine_rects
  
end
