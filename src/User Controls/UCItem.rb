#==============================================================================
# ** UCItem
#------------------------------------------------------------------------------
#  Represents an item on a window
#==============================================================================

class UCItem < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the item icon
  attr_reader :ucIcon
  # Label for the item name
  attr_reader :cItemName
  # Label for the item quantity
  attr_reader :cItemNumber
  # Item object
  attr_reader :item
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @ucIcon.visible = visible
    @cItemName.visible = visible
    @cItemNumber.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cItemName.active = active
    @cItemNumber.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     item : item object
  #     rect : rectangle to position the controls for the item
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, item, rect, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @item = item
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], item.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cItemName = CLabel.new(window, rects[1], item.name)
    @cItemName.active = active
    @cItemName.visible = visible
    @cItemName.cut_overflow = true
    
    @cItemNumber = CLabel.new(window, rects[2], 
                              sprintf(MENU_CONFIG::ITEM_NUMBER_PATTERN, 
                                      $game_party.item_number(item)), 2)
    @cItemNumber.active = active
    @cItemNumber.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cItemName.draw()
    @cItemNumber.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    rects[2] = Rect.new(rect.x,rect.y,32,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cItemName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cItemNumber
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end
