#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
#  This class performs the map screen processing.
#==============================================================================

class Scene_Map < Scene_Base
  
  #//////////////////////////////////////////////////////////////////////////
  # * Public Methods
  #//////////////////////////////////////////////////////////////////////////
  
  #--------------------------------------------------------------------------
  # * Create Snapshot for Using as Background of Another Screen
  #--------------------------------------------------------------------------
  def snapshot_for_background
    $game_temp.orig_background_bitmap.dispose
    $game_temp.background_bitmap.dispose
    $game_temp.orig_background_bitmap = Graphics.snap_to_bitmap
    $game_temp.background_bitmap = $game_temp.orig_background_bitmap.clone
    $game_temp.background_bitmap.blur
  end
  
end
