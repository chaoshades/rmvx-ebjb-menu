#==============================================================================
# ** Font
#------------------------------------------------------------------------------
#  Contains the different fonts
#==============================================================================

class Font
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Get Graph Label Font
  #--------------------------------------------------------------------------
  def self.graph_label_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Party Status Font
  #--------------------------------------------------------------------------
  def self.party_stat_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Save Location Font
  #--------------------------------------------------------------------------
  def self.save_location_font
    f = Font.new()
    f.size = 48
    f.bold = true
    f.italic = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Optimize Mode Font
  #--------------------------------------------------------------------------
  def self.optimize_mode_font
    f = Font.new()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Optimize Mode Header Font
  #--------------------------------------------------------------------------
  def self.optimize_mode_header_font
    f = Font.new()
    f.color = Color.system_color
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Stats Font
  #--------------------------------------------------------------------------
  def self.item_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Plus States Font
  #--------------------------------------------------------------------------
  def self.item_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Item Details Minus States Font
  #--------------------------------------------------------------------------
  def self.item_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details HP/MP Font
  #--------------------------------------------------------------------------
  def self.skill_details_stats_font
    f = Font.new()
    f.size = 12
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Plus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_plus_states_font
    f = Font.new()
    f.color = Color.power_up_color()
    f.size = 20
    f.bold = true
    return f
  end
  
  #--------------------------------------------------------------------------
  # * Get Skill Details Minus States Font
  #--------------------------------------------------------------------------
  def self.skill_details_minus_states_font
    f = Font.new()
    f.color = Color.power_down_color()
    f.size = 20
    f.bold = true
    return f
  end
  
end
