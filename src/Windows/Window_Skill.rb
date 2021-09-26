#==============================================================================
# ** Window_Skill
#------------------------------------------------------------------------------
#  This window displays a list of usable skills on the skill screen, etc.
#==============================================================================

class Window_Skill < Window_Selectable
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCSkill for every skill of a character
  attr_reader :ucSkillsList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current item
  #--------------------------------------------------------------------------
  # GET
  def selected_skill
    return (self.index < 0 ? nil : @data[self.index])
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
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor, dataview=nil)
    super(x, y, width, height)
    @column_max = 1
    @ucSkillsList = []
    window_update(actor, dataview)
    self.index = 0
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor, dataview=nil)
    @data = []
    if actor != nil
      @actor = actor
      if dataview != nil
        skills = apply_dataview(dataview, actor.skills)
      else
        skills = actor.skills
      end
      
      for skill in skills
        if skill != nil
          @data.push(skill)
          if skill.id == actor.last_skill_id
            self.index = @data.size - 1
          end
        end
      end
      @item_max = @data.size
      create_contents()
      @ucSkillsList.clear()
      for i in 0..@item_max-1
        @ucSkillsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucSkillsList.each() { |ucSkill| ucSkill.draw() }
  end
  
  #--------------------------------------------------------------------------
  # * Update Help Text
  #--------------------------------------------------------------------------
  def update_help
    if @help_window.is_a?(Window_Help)
      @help_window.set_text(skill == nil ? "" : skill.description)
    else
      if selected_skill != nil
        @help_window.window_update(selected_skill.description)
      else
        @help_window.window_update("")
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update Detail Window
  #--------------------------------------------------------------------------
  def update_detail
    if selected_skill != nil
      @detail_window.window_update(selected_skill)
    else
      @detail_window.window_update(nil)
    end
  end
  
  #--------------------------------------------------------------------------
  # * Determine if help/detail window can be switched
  #--------------------------------------------------------------------------
  def is_switchable
    return selected_skill != nil && selected_skill.is_a?(RPG::Skill)
  end
  
  #--------------------------------------------------------------------------
  # * Whether or not to display in enabled state
  #     skill : skill
  #--------------------------------------------------------------------------
  def enable?(skill)
    return @actor.skill_can_use?(skill)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for SkillsList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    skill = @data[index]
    rect = item_rect(index, true)
    
    ucSkill = UCSkill.new(self, skill, rect, @actor.calc_mp_cost(skill))
    ucSkill.active = enable?(skill)
    
    return ucSkill
  end
  private :create_item
  
  #--------------------------------------------------------------------------
  # * Apply dataview to a list
  #     list : data to apply the dataview
  #--------------------------------------------------------------------------
  def apply_dataview(dataview, list)
    new_list = []
    
    if dataview.is_a?(Comparer)
      new_list = list.sort{|x,y| dataview.compare(x,y)}
    elsif dataview.is_a?(Filter)
      new_list = list.find_all{|x| dataview.apply(x)}
    end
    
    return new_list
  end
  private :apply_dataview
  
end
