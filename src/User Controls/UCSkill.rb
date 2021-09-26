#==============================================================================
# ** UCSkill
#------------------------------------------------------------------------------
#  Represents a skill on a window
#==============================================================================

class UCSkill < UserControl
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCIcon for the skill icon
  attr_reader :ucIcon
  # Label for the skill name
  attr_reader :cSkillName
  # Label for the skill mp cost
  attr_reader :cSkillMpCost
  # Skill object
  attr_reader :skill
  
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
    @cSkillName.visible = visible
    @cSkillMpCost.visible = visible
  end

  #--------------------------------------------------------------------------
  # * Set the active property of the controls in the user control
  #--------------------------------------------------------------------------
  # SET
  def active=(active)
    @active = active
    @ucIcon.active = active
    @cSkillName.active = active
    @cSkillMpCost.active = active
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     window : window in which the control will appear
  #     skill : skill object
  #     rect : rectangle to position the controls for the skill
  #     mpCost : skill mp cost
  #     spacing : spacing between controls
  #     active : control activity
  #     visible : control visibility
  #--------------------------------------------------------------------------
  def initialize(window, skill, rect, mpCost, spacing=8,
                 active=true, visible=true)
    super(active, visible)
    @skill = skill
    
    # Determine rectangles to position controls
    rects = determine_rects(rect, spacing)
    
    @ucIcon = UCIcon.new(window, rects[0], skill.icon_index)
    @ucIcon.active = active
    @ucIcon.visible = visible
    
    @cSkillName = CLabel.new(window, rects[1], skill.name)
    @cSkillName.active = active
    @cSkillName.visible = visible
    @cSkillName.cut_overflow = true
     
    @cSkillMpCost = CLabel.new(window, rects[2], 
                               sprintf(MENU_CONFIG::SKILL_COST_PATTERN, mpCost), 2)
    @cSkillMpCost.active = active
    @cSkillMpCost.visible = visible
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Draw the background image on the window
  #--------------------------------------------------------------------------
  def draw()
    @ucIcon.draw()
    @cSkillName.draw()
    @cSkillMpCost.draw()
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
    rects[2] = Rect.new(rect.x,rect.y,48,rect.height)
    
    # Rects Adjustments
    
    # ucIcon
    # Nothing to do
    
    # cSkillName
    rects[1].x += rects[0].width
    rects[1].width = rect.width - rects[0].width - rects[2].width - spacing
    
    # cSkillMpCost
    rects[2].x += rect.width - rects[2].width
    
    return rects
  end
  private :determine_rects
  
end
