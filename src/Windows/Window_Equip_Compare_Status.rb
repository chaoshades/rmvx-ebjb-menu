#==============================================================================
# ** Window_Equip_Compare_Status
#------------------------------------------------------------------------------
#  This window displays actor parameter changes on the equipment screen, etc.
#==============================================================================

class Window_Equip_Compare_Status < Window_Scrollable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # UCCompareCharStatus for the equipment status compare
  attr_reader :ucCompareStat
  # Label for the Elemental Resistance graph
  attr_reader :cElementalResistLabel
  # Elemental Resistance graph
  attr_reader :ucElementalResistGraph
  # Label for the States Resistance graph
  attr_reader :cStatesResistLabel
  # States Resistance graph
  attr_reader :ucStatesResistGraph
  # Actor object
  attr_reader :actor
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     actor : actor object
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, actor)
    super(x, y, width, height)
    
    self.contents.dispose
    self.contents = Bitmap.new((self.width - 32)*2, self.height - 32)
    
    width = ((self.contents.width)/2).floor
    
    @actor = actor
    
    @ucCompareStat = UCCompareCharStatus.new(self, actor, Rect.new(0,0,width,self.contents.height))
    
    @cElementalResistLabel = CLabel.new(self, Rect.new(width,0,185,WLH), Vocab::elem_resist_label)

    @ucElementalResistGraph = UCGraph.new(self, width+100, 85, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                          MENU_CONFIG::ELEM_RES_MAX,
                                          MENU_CONFIG::ELEM_RES_MIN,
                                          Font.graph_label_font,
                                          Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                          Color.neg_resist_gauge_color1, Color.neg_resist_gauge_color2, 
                                          nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                               
    @cStatesResistLabel = CLabel.new(self, Rect.new(width,160,185,WLH), Vocab::states_resist_label)
    
    @ucStatesResistGraph = UCGraph.new(self, width+100,245, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                       MENU_CONFIG::STATES_RES_MAX,
                                       MENU_CONFIG::STATES_RES_MIN,
                                       Font.graph_label_font,
                                       Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                       nil, nil,
                                       nil, 2, Color.resist_border_color1, Color.resist_border_color2)
    
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Frame update
  #--------------------------------------------------------------------------
  def update
    super
    # Scroll
    if self.active
      scroll_max = [self.contents.width - (self.width - 32), 0].max
      if Input.press?(Input::Y)
        self.ox = [self.ox - (self.width - 32), 0].max
      elsif Input.press?(Input::Z)
        self.ox = [self.ox + (self.width - 32), scroll_max].min
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(equipIndex, newItem)
    if equipIndex != nil && newItem != nil
      # Test equipment with a clone to compare stats
      compare_actor = @actor.clone
      compare_actor.change_equip(equipIndex, newItem, true)
      
      @ucCompareStat.update_status(compare_actor)
      
      #------------------------------------------
      # Resistances section
      #------------------------------------------
      elements = []
      for i in 9..16       
        elements.push(GraphElement.new(CORE_CONFIG::ELEMENT_ICONS[i], compare_actor.element_rate(i)))
      end
      @ucElementalResistGraph.elements = elements

      elements = []
      for i in 1 .. $data_states.size-1
        state = $data_states[i]
        if !state.nonresistance         
          elements.push(GraphElement.new(state.icon_index, compare_actor.state_probability(state.id)))
        end
      end
      @ucStatesResistGraph.elements = elements
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucCompareStat.draw()
    @cElementalResistLabel.draw()
    @ucElementalResistGraph.draw()
    @cStatesResistLabel.draw()
    @ucStatesResistGraph.draw()
  end
  
end
