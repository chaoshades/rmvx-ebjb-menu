#==============================================================================
# ** Window_Status
#------------------------------------------------------------------------------
#  This window displays full status specs on the status screen.
#==============================================================================

class Window_Status < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Control that shows the character status
  attr_reader :ucCharStatus
  # Label for the Elemental Resistance graph
  attr_reader :cElementalResistLabel
  # Elemental Resistance graph
  attr_reader :ucElementalResistGraph
  # Label for the States Resistance graph
  attr_reader :cStatesResistLabel
  # States Resistance graph
  attr_reader :ucStatesResistGraph
  
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
    
    @ucCharStatus = UCCharStatus.new(self, actor, Rect.new(0,0,190,240))
    
    @cElementalResistLabel = CLabel.new(self, Rect.new(0,260,185,WLH), Vocab::elem_resist_label)

    @ucElementalResistGraph = UCGraph.new(self, 100, 345, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                          MENU_CONFIG::ELEM_RES_MAX,
                                          MENU_CONFIG::ELEM_RES_MIN,
                                          Font.graph_label_font,
                                          Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                          Color.neg_resist_gauge_color1, Color.neg_resist_gauge_color2, 
                                          nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                               
    @cStatesResistLabel = CLabel.new(self, Rect.new(205,260,185,WLH), Vocab::states_resist_label)
    
    @ucStatesResistGraph = UCGraph.new(self, 310, 345, 40, [0], MENU_CONFIG::PERCENTAGE_PATTERN,
                                       MENU_CONFIG::STATES_RES_MAX,
                                       MENU_CONFIG::STATES_RES_MIN,
                                       Font.graph_label_font,
                                       Color.pos_resist_gauge_color1, Color.pos_resist_gauge_color2,
                                       nil, nil,
                                       nil, 2, Color.resist_border_color1, Color.resist_border_color2)
                                     
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    @ucCharStatus.ucActStates.update()
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil                              
      #------------------------------------------
      # Resistances section
      #------------------------------------------
      elements = []
      for i in 9..16
        elements.push(GraphElement.new(CORE_CONFIG::ELEMENT_ICONS[i], actor.element_rate(i)))
      end
      @ucElementalResistGraph.elements = elements

      elements = []
      for i in 1 .. $data_states.size-1
        state = $data_states[i]
        if !state.nonresistance         
          elements.push(GraphElement.new(state.icon_index, actor.state_probability(state.id)))
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
    @ucCharStatus.draw()
    @cElementalResistLabel.draw()
    @ucElementalResistGraph.draw()
    @cStatesResistLabel.draw()
    @ucStatesResistGraph.draw()
  end
  
end
