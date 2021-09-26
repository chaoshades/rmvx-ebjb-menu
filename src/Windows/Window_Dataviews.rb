#===============================================================================
# ** Window_Dataviews
#------------------------------------------------------------------------------
#  This window displays views that can be applied to filter or sort lists
#===============================================================================

class Window_Dataviews < Window_Selectable
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Array of dataviews (filters or comparers)
  attr_reader :viewsList

  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get the current comparer
  #--------------------------------------------------------------------------
  # GET
  def selected_view
    return @data[self.index].view
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
  #     views : views list
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, views)
    super(x, y, width, height, 8, 24, true, 24, 2)
    @row_max = 1
    @column_max = views.size
    
    @viewsList = []
    window_update(views)
    self.index = 0
  end
  
  #--------------------------------------------------------------------------
  # * Update
  #     views : views list
  #--------------------------------------------------------------------------
  def window_update(views)
    @data = []
    if views != nil
      for view in views
        if view != nil
          @data.push(view)
        end
      end
      @item_max = @data.size
      create_contents()
      @viewsList.clear()
      for i in 0..@item_max-1
        @viewsList.push(create_item(i))
      end
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @viewsList.each() { |view| view.draw() }
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Private Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create an item for the views list
  #     index : item index
  #--------------------------------------------------------------------------
  def create_item(index)
    dataview = @data[index]
    rect = item_rect(index)
    
    viewItem = UCLabelIcon.new(self, Rect.new(rect.x,rect.y,24,24),
                              Rect.new(rect.x,rect.y,24,24),
                              dataview.label,
                              dataview.icon_index)
    
    viewItem.cLabel.align = 1
    
    return viewItem
  end
  private :create_item
  
end
