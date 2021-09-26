#===============================================================================
# ** Window_Char_Image
#------------------------------------------------------------------------------
#  This window displays the actor background image
#===============================================================================

class Window_Char_Image < Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Attributes
  #//////////////////////////////////////////////////////////////////////////
  
  # CResizableImage to show the character image
  attr_reader :cBackCharImage
  
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
    @cBackCharImage = CResizableImage.new(self, Rect.new(0, 0, self.contents.width, self.contents.height), 
                         nil, nil, 0, 255, 2, 3)
    window_update(actor)
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # * Update
  #     actor : actor object
  #--------------------------------------------------------------------------
  def window_update(actor)
    if actor != nil
      bodyImg = MENU_CONFIG::BODY_IMAGES[actor.id]
      bitmap = Cache.picture(bodyImg.filename)
      @cBackCharImage.img_bitmap = bitmap
      @cBackCharImage.src_rect = Rect.new(bodyImg.src_rect.x, bodyImg.src_rect.y, 
                                          bitmap.width, bitmap.height)
    end
    refresh()
  end
  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh()
    self.contents.clear
    @cBackCharImage.draw()
  end
  
end
