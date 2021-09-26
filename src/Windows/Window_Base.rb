#===============================================================================
# ** Window_Base
#------------------------------------------------------------------------------
#  This is a superclass of all windows in the game. 
#===============================================================================

class Window_Base
  include EBJB
  
  #//////////////////////////////////////////////////////////////////////////
  # * Properties
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # Get Current Windowskin Settings
  #--------------------------------------------------------------------------
  # GET
  def current_windowskin_settings
    if $game_variables != nil
      winvar = YE::SYSTEM::WINDOW_VARIABLE
      if $game_variables[winvar] == 0
        $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
      elsif !MENU_CONFIG::WINDOW_HASH.include?($game_variables[winvar])
        $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
      end
      mso_windowskin = MENU_CONFIG::WINDOW_HASH[$game_variables[winvar]]
    else
      mso_windowskin = MENU_CONFIG::WINDOW_HASH[YE::SYSTEM::DEFAULT_WINDOW]
    end
    return mso_windowskin
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Constructors
  #//////////////////////////////////////////////////////////////////////////

  #--------------------------------------------------------------------------
  # Alias initialize
  #--------------------------------------------------------------------------
  alias initialize_window_mso initialize unless $@
  def initialize(x, y, width, height)
    self.update_windowskin_font
    initialize_window_mso(x, y, width, height)
    self.update_windowskin
  end
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # Update windowskin
  #--------------------------------------------------------------------------
  def update_windowskin
    mso_windowskin = current_windowskin_settings()
    
    self.windowskin = Cache.windows(mso_windowskin[1])
    self.opacity = mso_windowskin[2]
    self.back_opacity = mso_windowskin[3]
  end
  
  #--------------------------------------------------------------------------
  # Update windowskin font
  #--------------------------------------------------------------------------
  def update_windowskin_font
    mso_windowskin = current_windowskin_settings()
    
    # Changes default font settings
    Font.default_bold = mso_windowskin[4][0]
    Font.default_italic = mso_windowskin[4][1]
    Font.default_shadow = mso_windowskin[4][2]
    Font.default_size = mso_windowskin[4][3]
    Font.default_name = mso_windowskin[4][4]
  end
    
end