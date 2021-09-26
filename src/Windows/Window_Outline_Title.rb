#==============================================================================
# ** Window_Outline_Title
#------------------------------------------------------------------------------
# Plot Summary Title Window Display
#==============================================================================

class Window_Outline_Title < Window_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # Label for the title
  attr_reader :cTitle
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     x : window X coordinate
  #     y : window Y coordinate
  #     width : window width
  #     height : window height
  #     text : text to display
  #--------------------------------------------------------------------------
  def initialize(x, y, width, height, text=nil)
    super(x, y, width, height)
    self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
    
    @cTitle = CLabel.new(self, Rect.new(0,0,width-32,WLH), "", 1, Font.bold_font)
    
    window_update(text)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Update
  #     text : text to display
  #--------------------------------------------------------------------------
  def window_update(text)
    if text != nil
      @cTitle.text = text
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cTitle.draw()
  end
  
end
