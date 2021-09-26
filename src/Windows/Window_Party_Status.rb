#==============================================================================
# ** Window_Party_Status
#------------------------------------------------------------------------------
#  This window displays party member status on the menu screen.
#==============================================================================

class Window_Party_Status < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of UCPartyCharStatus for every character in the party
  attr_reader :ucPartyCharStatusList
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     characters : characters list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, characters)
    super(x, y, width, height, 8, height - 32)
    @column_max = 4
    @ucPartyCharStatusList = []
    window_update(characters)
    self.index = -1
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @ucPartyCharStatusList.each() { |partyCharData| partyCharData.draw() }
  end

  #--------------------------------------------------------------------------
  # * Update
  #     characters : characters list
  #--------------------------------------------------------------------------
  def window_update(characters)
    @data = []
    if characters != nil
      for char in characters
        if char != nil
          @data.push(char)
        end
      end
      @item_max = @data.size
      create_contents()
      @ucPartyCharStatusList.clear()
      for i in 0..@item_max-1
        @ucPartyCharStatusList.push(create_item(i))
      end
    end
    refresh()
  end  
  
  #--------------------------------------------------------------------------
  # * Frame Update (for the icons list that refreshed after a timeout)
  #--------------------------------------------------------------------------
  def update
    super
    for charStatus in @ucPartyCharStatusList
      charStatus.ucActStates.update()
    end
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for PartyCharStatusList
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    actor = @data[index]
    rect = item_rect(index, true, true)
    
    charStatus = UCPartyCharStatus.new(self, actor, rect)
    
    return charStatus
  end
  private :create_item
  
end
