#==============================================================================
# ** UCEquipItem
#------------------------------------------------------------------------------
#  Represents an equip item on a window
#==============================================================================

class UCEquipItem < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the item kind
  attr_reader :cEquipKind
  # UCIcon for the item icon
  attr_reader :ucIcon
  # Label for the item name
  attr_reader :cEquipName
  # Item object
  attr_reader :equipItem
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Set the visible property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def visible=(visible)
    @visible = visible
    @cEquipKind.visible = visible
    @ucIcon.visible = visible
    @cEquipName.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @cEquipKind.active = active
    @ucIcon.active = active
    @cEquipName.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     equipItem : item object
  #     rect : rectangle to position the controls for the item
  #     equipKindLabel : text to show for the item kind
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, equipItem, rect, equipKindLabel, 
                 active=true, visible=true)
    super(active, visible)
    @equipItem = equipItem
    
    @cEquipKind = CLabel.new(window, rect, equipKindLabel)
    @cEquipKind.active = active
    @cEquipKind.visible = visible
    
    if equipItem != nil
      icon_index = equipItem.icon_index
      name = equipItem.name
    else
      icon_index = nil
      name = nil
    end
    
    # Changes y to draw items under the equipkind label
    temp = Rect.new(rect.x,rect.y+rect.height,rect.width,rect.height)
    
    # Determine rectangles to position controls
    rects = determine_rects(temp)

    @ucIcon = UCIcon.new(window, rects[0], icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cEquipName = CLabel.new(window, rects[1], name)
    @cEquipName.active = active
    @cEquipName.visible = visible
    @cEquipName.cut_overflow = true
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @cEquipKind.draw()
    @ucIcon.draw()
    @cEquipName.draw()
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
    rects[0] = Rect.new(rect.x,rect.y,24,rect.height)
    rects[1] = Rect.new(rect.x,rect.y,rect.width,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cEquipName
    rects[1].x += rects[0].width
    rects[1].width -= rects[0].width
    
    return rects
  end
  private :determine_rects
  
end
