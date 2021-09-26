#~ #==========================================================================
#~ # ● [VX] ◦ Neo Save System V ◦ □
#~ #---------------------------------------------------------------------------
#~ # ◦ Author: Woratana [woratana@hotmail.com]
#~ # ◦ Thaiware RPG Maker Community
#~ # ◦ Last Updated:
#~ # ◦ Version: 3.0 -> 5.0
#~ # ◦ Continued support by Helladen 
#~ # ◦ (Screen Shot credit Wortana, Andreas21, and Cybersam)
#~ #---------------------------------------------------------------------------
#~ # ◦ Log V:
#~ # - Screenshot support for those who want tone/weather/sprites and
#~ #   unlike NSS 1.0 the screen is now centered.
#~ # - Added an option to stay in save screen after you save the game
#~ #---------------------------------------------------------------------------
#~ # ◦ Log IV:
#~ # - New addition for hiding map names. You can control the switch to
#~ #   allow MAP_NO_NAME_LIST to work or not.
#~ # - Revised some of the settings and script organization.
#~ # - Added an option to disable the vocab::Gold text right of the number.
#~ # - Added an option to use default opacity or not.
#~ # - Swap tile compatibility support.
#~ #---------------------------------------------------------------------------
#~ # ◦ Log III:
#~ # - Change back to draw tile map as screenshot. Don't need any image.
#~ # - For drawing tile map, the characters won't show on the tile map.
#~ #---------------------------------------------------------------------------
#~ # ◦ Log II:
#~ # - Screenshot DLL is not work with Vista Aero, so I remove it
#~ #   and use image for each map instead of screenshot.
#~ # - Actor's level in last version (V.1) is incorrect.
#~ #---------------------------------------------------------------------------
#~ # ◦ Features:
#~ # - Unlimited save slots, you can choose max save slot
#~ # - Many configuration options
#~ # - Swap tile support
#~ # - You can use image for scene's background
#~ # - Choose your save file's name, and folder to store save files
#~ # - Choose to show only information you want
#~ # - Editable text for information's title
#~ # - Draw tile map for map that player is currently on.
#~ # - Remove text you don't want from map's name (e.g. tags for special script)
#~ # - Choose map that you don't want to show the name on
#~ # - Include save confirmation window before overwrite old save
#~ #===========================================================================

module Wora_NSS Wora_NSS
  #==========================================================================
  # * START NEO SAVE SYSTEM - SETUP
  #--------------------------------------------------------------------------
  OPACITY_DEFAULT = true # This will use the default opacity for windows
                         # Please note that this will affect both opacitys below
  NSS_WINDOW_OPACITY = 255 # All windows' opacity (Lowest 0 - 255 Highest)
  # You can change this to 0 in case you want to use image for background
  NSS_IMAGE_BG = '' # Background image file name, it must be in folder Picture
  #                   use '' for no background
  NSS_IMAGE_BG_OPACITY = 255 # Opacity for background image
  
  # If you use the screen shot method this does not matter
  SWAP_TILE = false # Make this false if you don't use the swap_tile script
  SWAP_TILE_SWITCH = 84 # The switch needs to be the same as your swap tile
  #                       switch, but if SWAP_TILE is false it does not matter
  
  # If this is true it will screen shot the map, if false it will draw it
  SCREENSHOT_IMAGE = true # Drawing the map is good because it doesn't require
  # a .DLL or images for the screen shot, but it has sprites, tone, and
  # weather. You need to turn on swap tile if you have this as false.
  
  IMAGE_FILETYPE = '.png' # Image type for screenshot
  # '.bmp', or '.jpg', or '.png'
  
  # If this is true then the scene will not change when you save the game 
  SCENE_CHANGE = false  # Changes Scene to map if true

  MAX_SAVE_SLOT = 20 # Max save slots
  SLOT_NAME = 'SLOT {id}'
  # Name of the slot (show in save slots list), use {id} for slot ID
  SAVE_FILE_NAME = 'Save {id}.rvdata'
  # Save file name, you can also change its file type from .rvdata to other
  
  # Use {id} for save slot ID
  SAVE_PATH = '' # Path to store save file, e.g. 'Save/' or '' (for game folder)
  SAVED_SLOT_ICON = 133 # Icon Index for saved slot
  
  EMPTY_SLOT_ICON = 141 # Icon Index for empty slot
  EMPTY_SLOT_TEXT = 'Empty' # Text to show for empty slot's data
  
  DRAW_GOLD = true # Draw Gold
  DRAW_PLAYTIME = true # Draw Playtime
  DRAW_LOCATION = true # Draw location
  DRAW_FACE = true # Draw Actor's face
  DRAW_LEVEL = true # Draw Actor's level
  DRAW_NAME = true # Draw Actor's name
  DRAW_TEXT_GOLD = false # Draw the vocab::Gold text to the right of the number
  
  PLAYTIME_TEXT = 'Play Time: '
  GOLD_TEXT = 'Gold: '
  LOCATION_TEXT = 'Location: '
  LV_TEXT = 'Lv. '
  
  MAP_NAME_TEXT_SUB = %w{}
  # Text that you want to remove from map name,
  # e.g. %w{[LN] [DA]} will remove text '[LN]' and '[DA]' from map name
  MAP_NO_NAME_LIST = [2] # ID of Map that will not show map name, e.g. [1,2,3]
  MAP_NO_NAME = '???' # What you will use to call the map in the no name list

  # This is a switch that can activate or deactivate maps from being displayed as
  # MAP_NO_NAME. If it is off then maps will return back to normal.
  MAP_NO_NAME_SWITCH = 95 # This switch has to be on for MAP_NO_NAME_LIST to work
  
  MAP_BORDER = Color.new(0,0,0,200) # Map image border color (R,G,B,Opacity)
  FACE_BORDER = Color.new(0,0,0,200) # Face border color
  
  # Save confirmation window
  SFC_Text_Confirm = 'Confirm to save' # Text to confirm to save file
  SFC_Text_Cancel = 'Cancel' # Text to cancel to save
  SFC_Window_Width = 200 # Width of Confirmation Window
  SFC_Window_X_Offset = 0 # Move Confirmation Window horizontally
  SFC_Window_Y_Offset = 0 # Move Confirmation Window vertically
  
  #-------------------------------------------------------------------------
  # END NEO SAVE SYSTEM - SETUP (Edit below at your own risk)
  #=========================================================================
  
#~   #-------------------------------------------------------------
#~   # Screenshot V2 by Andreas21 and Cybersam
#~   #-------------------------------------------------------------
#~   @screen = Win32API.new 'screenshot', 'Screenshot', %w(l l l l p l l), ''
#~   @readini = Win32API.new 'kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 'l'
#~   @findwindow = Win32API.new 'user32', 'FindWindowA', %w(p p), 'l' 
#~   module_function
#~   def self.shot(file_name)
#~     case IMAGE_FILETYPE
#~     when '.bmp'; typid = 0
#~     when '.jpg'; typid = 1
#~     when '.png'; typid = 2
#~     end
#~     # Get Screenshot
#~     filename = file_name + IMAGE_FILETYPE
#~     @screen.call(0, 0, Graphics.width, Graphics.height, filename, self.handel,
#~     typid)
#~   end
#~   def self.handel
#~     game_name = "\0" * 256
#~     @readini.call('Game','Title','',game_name,255,".\\Game.ini")
#~     game_name.delete!("\0")
#~     return @findwindow.call('RGSS Player',game_name)
#~   end
  
end

#~ class Scene_File < Scene_Base
#~   include Wora_NSS
#~   attr_reader :window_slotdetail
#~   #-------------------------------------------------------------------------
#~   # * Start processing
#~   #-------------------------------------------------------------------------
#~   def start
#~     super
#~     create_menu_background
#~     if NSS_IMAGE_BG != ''
#~       @bg = Sprite.new
#~       @bg.bitmap = Cache.picture(NSS_IMAGE_BG)
#~       @bg.opacity = NSS_IMAGE_BG_OPACITY
#~     end
#~     @help_window = Window_Help.new
#~     command = []
#~     (1..MAX_SAVE_SLOT).each do |i|
#~       command << SLOT_NAME.clone.gsub!(/\{ID\}/i) { i.to_s }
#~     end
#~     @window_slotdetail = Window_NSS_SlotDetail.new
#~     @window_slotlist = Window_SlotList.new(160, command)
#~     @window_slotlist.y = @help_window.height
#~     @window_slotlist.height = Graphics.height - @help_window.height
#~     if OPACITY_DEFAULT == false
#~     @help_window.opacity = NSS_WINDOW_OPACITY
#~     @window_slotdetail.opacity = @window_slotlist.opacity = NSS_WINDOW_OPACITY
#~     end

#~   # Create Folder for Save file
#~   if SAVE_PATH != ''
#~     Dir.mkdir(SAVE_PATH) if !FileTest.directory?(SAVE_PATH)
#~   end
#~     if @saving
#~       @index = $game_temp.last_file_index
#~       @help_window.set_text(Vocab::SaveMessage)
#~     else
#~       @index = self.latest_file_index
#~       @help_window.set_text(Vocab::LoadMessage)
#~       (1..MAX_SAVE_SLOT).each do |i|
#~         @window_slotlist.draw_item(i-1, false) if !@window_slotdetail.file_exist?(i)
#~      end
#~     end
#~     @window_slotlist.index = @index
#~     # Draw Information
#~     @last_slot_index = @window_slotlist.index
#~     @window_slotdetail.draw_data(@last_slot_index + 1)
#~   end
#~   #--------------------------------------------------------------------------  
#~   # * Termination Processing
#~   #--------------------------------------------------------------------------
#~   def terminate
#~     super
#~     dispose_menu_background
#~     unless @bg.nil?
#~       @bg.bitmap.dispose
#~       @bg.dispose
#~     end
#~     @window_slotlist.dispose
#~     @window_slotdetail.dispose
#~     @help_window.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Frame Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     if !@confirm_window.nil?
#~       @confirm_window.update
#~       if Input.trigger?(Input::C)
#~         if @confirm_window.index == 0
#~           determine_savefile
#~           @confirm_window.dispose
#~           @confirm_window = nil
#~         else
#~           Sound.play_cancel
#~           @confirm_window.dispose
#~           @confirm_window = nil
#~         end
#~       elsif Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       @confirm_window.dispose
#~       @confirm_window = nil
#~       end
#~     else
#~       update_menu_background
#~       @window_slotlist.update
#~       if @window_slotlist.index != @last_slot_index
#~         @last_slot_index = @window_slotlist.index
#~         @window_slotdetail.draw_data(@last_slot_index + 1)
#~       end
#~       @help_window.update
#~       update_savefile_selection
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Update Save File Selection
#~   #--------------------------------------------------------------------------
#~   def update_savefile_selection
#~     if Input.trigger?(Input::C)
#~       if @saving and @window_slotdetail.file_exist?(@last_slot_index + 1)
#~         Sound.play_decision
#~         text1 = SFC_Text_Confirm
#~         text2 = SFC_Text_Cancel
#~         @confirm_window = Window_Command.new(SFC_Window_Width,[text1,text2])
#~         @confirm_window.x = ((544 - @confirm_window.width) / 2) + SFC_Window_X_Offset
#~         @confirm_window.y = ((416 - @confirm_window.height) / 2) + SFC_Window_Y_Offset
#~       else
#~         determine_savefile
#~       end
#~     elsif Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       return_scene
#~     end
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # * Execute Save
#~   #--------------------------------------------------------------------------
#~   def do_save
#~     if SCREENSHOT_IMAGE
#~     File.rename(SAVE_PATH + 'temp' + IMAGE_FILETYPE,
#~     make_filename(@last_slot_index).gsub(/\..*$/){ '_ss' } + IMAGE_FILETYPE)  
#~     end  
#~     file = File.open(make_filename(@last_slot_index), "wb")
#~     write_save_data(file)
#~     file.close   
#~     if SCENE_CHANGE
#~     $scene = Scene_Map.new
#~     else
#~     $scene = Scene_File.new(true, false, false)
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Execute Load
#~   #--------------------------------------------------------------------------
#~   def do_load
#~     file = File.open(make_filename(@last_slot_index), "rb")
#~     read_save_data(file)
#~     file.close
#~     $scene = Scene_Map.new
#~     RPG::BGM.fade(1500)
#~     Graphics.fadeout(60)
#~     Graphics.wait(40)
#~     @last_bgm.play
#~     @last_bgs.play
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Confirm Save File
#~   #--------------------------------------------------------------------------
#~   def determine_savefile
#~     if @saving
#~       Sound.play_save
#~       do_save
#~     else
#~       if @window_slotdetail.file_exist?(@last_slot_index + 1)
#~         Sound.play_load
#~         do_load
#~       else
#~         Sound.play_buzzer
#~         return
#~       end
#~     end
#~     $game_temp.last_file_index = @last_slot_index
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Create Filename
#~   #     file_index : save file index (0-3)
#~   #--------------------------------------------------------------------------
#~   def make_filename(file_index)
#~     return SAVE_PATH + SAVE_FILE_NAME.gsub(/\{ID\}/i) { (file_index + 1).to_s }
#~   end
#~   #--------------------------------------------------------------------------
#~   # * Select File With Newest Timestamp
#~   #--------------------------------------------------------------------------
#~   def latest_file_index
#~     latest_index = 0
#~     latest_time = Time.at(0)
#~     (1..MAX_SAVE_SLOT).each do |i|
#~       file_name = make_filename(i - 1)
#~       next if !@window_slotdetail.file_exist?(i)
#~       file_time = File.mtime(file_name)
#~       if file_time > latest_time
#~         latest_time = file_time
#~         latest_index = i - 1
#~       end
#~     end
#~     return latest_index
#~   end

#~ class Window_SlotList < Window_Command
#~   #--------------------------------------------------------------------------
#~   # * Draw Item
#~   #--------------------------------------------------------------------------
#~   def draw_item(index, enabled = true)
#~     rect = item_rect(index)
#~     rect.x += 4
#~     rect.width -= 8
#~     icon_index = 0
#~     self.contents.clear_rect(rect)
#~     if $scene.window_slotdetail.file_exist?(index + 1)
#~       icon_index = Wora_NSS::SAVED_SLOT_ICON
#~     else
#~       icon_index = Wora_NSS::EMPTY_SLOT_ICON
#~     end
#~     if !icon_index.nil?
#~       rect.x -= 4
#~       draw_icon(icon_index, rect.x, rect.y, enabled) # Draw Icon
#~       rect.x += 26
#~       rect.width -= 20
#~     end
#~     self.contents.clear_rect(rect)
#~     self.contents.font.color = normal_color
#~     self.contents.font.color.alpha = enabled ? 255 : 128
#~     self.contents.draw_text(rect, @commands[index])
#~   end
#~   
#~   def cursor_down(wrap = false)
#~     if @index < @item_max - 1 or wrap
#~       @index = (@index + 1) % @item_max
#~     end
#~   end

#~   def cursor_up(wrap = false)
#~     if @index > 0 or wrap
#~       @index = (@index - 1 + @item_max) % @item_max
#~     end
#~   end
#~ end

#~ class Window_NSS_SlotDetail < Window_Base
#~   include Wora_NSS
#~   def initialize
#~     super(160, 56, 384, 360)
#~     @data = []
#~     @exist_list = []
#~     @bitmap_list = {}
#~     @map_name = []
#~   end
#~   
#~   def dispose
#~     dispose_tilemap
#~     super
#~   end

#~   def draw_data(slot_id)
#~     contents.clear # 352, 328
#~     dispose_tilemap
#~     load_save_data(slot_id) if @data[slot_id].nil?
#~     if @exist_list[slot_id]
#~       save_data = @data[slot_id]
#~       # DRAW SCREENSHOT
#~      contents.fill_rect(0,30,352,160, MAP_BORDER)
#~      if SCREENSHOT_IMAGE
#~       if save_data['ss']
#~         bitmap = get_bitmap(save_data['ss_path'])
#~         rect = Rect.new((Graphics.width-348)/2,(Graphics.height-156)/2,348,156)
#~         contents.blt(2,32,bitmap,rect)
#~       end
#~      else 
#~       if SWAP_TILE and $game_switches[SWAP_TILE_SWITCH]
#~       create_swaptilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
#~       save_data['gamemap'].display_y)
#~       else
#~       create_tilemap(save_data['gamemap'].data, save_data['gamemap'].display_x,
#~       save_data['gamemap'].display_y)
#~       end
#~      end
#~       if DRAW_GOLD
#~         # DRAW GOLD
#~         gold_textsize = contents.text_size(save_data['gamepar'].gold).width
#~         goldt_textsize = contents.text_size(GOLD_TEXT).width  
#~         contents.font.color = system_color
#~         contents.draw_text(0, 0, goldt_textsize, WLH, GOLD_TEXT)
#~         contents.font.color = normal_color
#~         contents.draw_text(goldt_textsize, 0, gold_textsize, WLH, save_data['gamepar'].gold)  
#~        if DRAW_TEXT_GOLD == false
#~         gold_textsize = 0
#~         goldt_textsize = 0    
#~        else
#~         contents.draw_text(goldt_textsize + gold_textsize, 0, 200, WLH, Vocab::gold)
#~        end
#~       end
#~       if DRAW_PLAYTIME
#~         # DRAW PLAYTIME
#~         hour = save_data['total_sec'] / 60 / 60
#~         min = save_data['total_sec'] / 60 % 60
#~         sec = save_data['total_sec'] % 60
#~         time_string = sprintf("%02d:%02d:%02d", hour, min, sec)
#~         pt_textsize = contents.text_size(PLAYTIME_TEXT).width
#~         ts_textsize = contents.text_size(time_string).width
#~         contents.font.color = system_color
#~         contents.draw_text(contents.width - ts_textsize - pt_textsize, 0,
#~         pt_textsize, WLH, PLAYTIME_TEXT)
#~         contents.draw_text(goldt_textsize + gold_textsize,0,200,WLH, Vocab::gold)
#~         contents.font.color = normal_color
#~         contents.draw_text(0, 0, contents.width, WLH, time_string, 2)
#~       end
#~       if DRAW_LOCATION
#~         # DRAW LOCATION
#~         lc_textsize = contents.text_size(LOCATION_TEXT).width
#~         mn_textsize = contents.text_size(save_data['map_name']).width
#~         contents.font.color = system_color
#~         contents.draw_text(0, 190, contents.width, WLH, LOCATION_TEXT)
#~         contents.font.color = normal_color
#~         contents.draw_text(lc_textsize, 190, contents.width, WLH, save_data['map_name'])
#~       end
#~         # DRAW FACE & Level & Name
#~         save_data['gamepar'].members.each_index do |i|
#~           actor = save_data['gameactor'][save_data['gamepar'].members[i].id]
#~           face_x_base = (i*80) + (i*8)
#~           face_y_base = 216
#~           lvn_y_plus = 10
#~           lv_textsize = contents.text_size(actor.level).width
#~           lvt_textsize = contents.text_size(LV_TEXT).width
#~         if DRAW_FACE
#~           # Draw Face
#~           contents.fill_rect(face_x_base, face_y_base, 84, 84, FACE_BORDER)
#~           draw_face(actor.face_name, actor.face_index, face_x_base + 2,
#~           face_y_base + 2, 80)
#~         end
#~         if DRAW_LEVEL
#~           # Draw Level
#~           contents.font.color = system_color
#~           contents.draw_text(face_x_base + 2 + 80 - lv_textsize - lvt_textsize,
#~           face_y_base + 2 + 80 - WLH + lvn_y_plus, lvt_textsize, WLH, LV_TEXT)
#~           contents.font.color = normal_color
#~           contents.draw_text(face_x_base + 2 + 80 - lv_textsize,
#~           face_y_base + 2 + 80 - WLH + lvn_y_plus, lv_textsize, WLH, actor.level)
#~         end
#~         if DRAW_NAME
#~           # Draw Name
#~           contents.draw_text(face_x_base, face_y_base + 2 + 80 + lvn_y_plus - 6, 84,
#~           WLH, actor.name, 1)
#~         end
#~       end
#~     else
#~       contents.draw_text(0,0, contents.width, contents.height - WLH, EMPTY_SLOT_TEXT, 1)
#~    end
#~   end
#~   
#~   def load_save_data(slot_id)
#~     file_name = make_filename(slot_id)
#~     if file_exist?(slot_id) or FileTest.exist?(file_name)
#~       @exist_list[slot_id] = true
#~       @data[slot_id] = {}
#~       # Start load data
#~       file = File.open(file_name, "r")
#~       @data[slot_id]['time'] = file.mtime
#~       @data[slot_id]['char'] = Marshal.load(file)
#~       @data[slot_id]['frame'] = Marshal.load(file)
#~       @data[slot_id]['last_bgm'] = Marshal.load(file)
#~       @data[slot_id]['last_bgs'] = Marshal.load(file)
#~       @data[slot_id]['gamesys'] = Marshal.load(file)
#~       @data[slot_id]['gamemes'] = Marshal.load(file)
#~       @data[slot_id]['gameswi'] = Marshal.load(file)
#~       @data[slot_id]['gamevar'] = Marshal.load(file)
#~       @data[slot_id]['gameselfvar'] = Marshal.load(file)
#~       @data[slot_id]['gameactor'] = Marshal.load(file)
#~       @data[slot_id]['gamepar'] = Marshal.load(file)
#~       @data[slot_id]['gametro'] = Marshal.load(file)
#~       @data[slot_id]['gamemap'] = Marshal.load(file)
#~       @data[slot_id]['total_sec'] = @data[slot_id]['frame'] / Graphics.frame_rate
#~       if SCREENSHOT_IMAGE
#~       @data[slot_id]['ss_path'] = file_name.gsub(/\..*$/){'_ss'} + IMAGE_FILETYPE
#~       @data[slot_id]['ss'] = FileTest.exist?(@data[slot_id]['ss_path'])
#~       end
#~       @data[slot_id]['map_name'] = get_mapname(@data[slot_id]['gamemap'].map_id)
#~       file.close
#~     else
#~       @exist_list[slot_id] = false
#~       @data[slot_id] = -1
#~     end
#~   end

#~   def make_filename(file_index)
#~     return SAVE_PATH + SAVE_FILE_NAME.gsub(/\{ID\}/i) { (file_index).to_s }
#~   end
#~   
#~   def file_exist?(slot_id)
#~     return @exist_list[slot_id] if !@exist_list[slot_id].nil?
#~     @exist_list[slot_id] = FileTest.exist?(make_filename(slot_id))
#~     return @exist_list[slot_id]
#~   end
#~   
#~   def get_bitmap(path)
#~     if !@bitmap_list.include?(path)
#~       @bitmap_list[path] = Bitmap.new(path)
#~     end
#~   return @bitmap_list[path]
#~   end
#~   
#~  def get_mapname(map_id)
#~     if @map_data.nil?
#~       @map_data = load_data("Data/MapInfos.rvdata")
#~     end
#~    if @map_name[map_id].nil?
#~      if MAP_NO_NAME_LIST.include?(map_id) and $game_switches[MAP_NO_NAME_SWITCH]
#~        @map_name[map_id] = MAP_NO_NAME
#~      else
#~        @map_name[map_id] = @map_data[map_id].name
#~      end  
#~        MAP_NAME_TEXT_SUB.each_index do |i|
#~        @map_name[map_id].sub!(MAP_NAME_TEXT_SUB[i], '')
#~        @mapname = @map_name[map_id]
#~      end 
#~    end
#~     return @map_name[map_id] 
#~  end  
#~   
#~   def create_tilemap(map_data, ox, oy)
#~     @viewport = Viewport.new(self.x + 2 + 16, self.y + 32 + 16, 348,156)
#~     @viewport.z = self.z
#~     @tilemap = Tilemap.new(@viewport)
#~     @tilemap.bitmaps[0] = Cache.system("TileA1")
#~     @tilemap.bitmaps[1] = Cache.system("TileA2")
#~     @tilemap.bitmaps[2] = Cache.system("TileA3")
#~     @tilemap.bitmaps[3] = Cache.system("TileA4")
#~     @tilemap.bitmaps[4] = Cache.system("TileA5")
#~     @tilemap.bitmaps[5] = Cache.system("TileB")
#~     @tilemap.bitmaps[6] = Cache.system("TileC")
#~     @tilemap.bitmaps[7] = Cache.system("TileD")
#~     @tilemap.bitmaps[8] = Cache.system("TileE")
#~     @tilemap.map_data = map_data
#~     @tilemap.ox = ox / 8 + 99
#~     @tilemap.oy = oy / 8 + 90
#~   end
#~   
#~     def create_swaptilemap(map_data, ox, oy)
#~     @viewport = Viewport.new(self.x + 2 + 16, self.y + 32 + 16, 348,156)
#~     @viewport.z = self.z
#~     @tilemap = Tilemap.new(@viewport)
#~     
#~     tile1 = Cache_Swap_Tiles.swap($tileA1 + ".png") rescue nil
#~     tile2 = Cache_Swap_Tiles.swap($tileA2 + ".png") rescue nil
#~     tile3 = Cache_Swap_Tiles.swap($tileA3 + ".png") rescue nil
#~     tile4 = Cache_Swap_Tiles.swap($tileA4 + ".png") rescue nil
#~     tile5 = Cache_Swap_Tiles.swap($tileA5 + ".png") rescue nil
#~     tile6 = Cache_Swap_Tiles.swap($tileB + ".png") rescue nil
#~     tile7 = Cache_Swap_Tiles.swap($tileC + ".png") rescue nil
#~     tile8 = Cache_Swap_Tiles.swap($tileD + ".png") rescue nil
#~     tile9 = Cache_Swap_Tiles.swap($tileE + ".png") rescue nil
#~     
#~ if $tileA1 != nil
#~ @tilemap.bitmaps[0] = tile1
#~ else
#~ @tilemap.bitmaps[0] = Cache.system("TileA1")
#~ end

#~ if $tileA2 != nil
#~ @tilemap.bitmaps[1] = tile2
#~ else
#~ @tilemap.bitmaps[1] = Cache.system("TileA2")
#~ end

#~ if $tileA3 != nil
#~ @tilemap.bitmaps[2] = tile3  
#~ else
#~ @tilemap.bitmaps[2] = Cache.system("TileA3")
#~ end  

#~ if $tileA4 != nil
#~ @tilemap.bitmaps[3] = tile4
#~ else
#~ @tilemap.bitmaps[3] = Cache.system("TileA4")
#~ end

#~ if $tileA5 != nil
#~ @tilemap.bitmaps[4] = tile5  
#~ else
#~ @tilemap.bitmaps[4] = Cache.system("TileA5")
#~ end

#~ if $tileB != nil
#~ @tilemap.bitmaps[5] = tile6
#~ else
#~ @tilemap.bitmaps[5] = Cache.system("TileB")  
#~ end  

#~ if $tileC != nil
#~ @tilemap.bitmaps[6] = tile7
#~ else
#~ @tilemap.bitmaps[6] = Cache.system("TileC")
#~ end  

#~ if $tileD != nil
#~ @tilemap.bitmaps[7] = tile8
#~ else
#~ @tilemap.bitmaps[7] = Cache.system("TileD")  
#~ end

#~ if $tileE != nil
#~ @tilemap.bitmaps[8] = tile9
#~ else
#~ @tilemap.bitmaps[8] = Cache.system("TileE")  
#~ end
#~   
#~     @tilemap.map_data = map_data
#~     @tilemap.ox = ox / 8 + 99
#~     @tilemap.oy = oy / 8 + 90
#~ end
#~   
#~   def dispose_tilemap
#~     unless @tilemap.nil?
#~       @tilemap.dispose
#~       @tilemap = nil
#~     end
#~   end
#~ end
#~ end

#~ class Scene_Title < Scene_Base
#~   def check_continue
#~     file_name = Wora_NSS::SAVE_PATH + Wora_NSS::SAVE_FILE_NAME.gsub(/\{ID\}/i) { '*' }
#~     @continue_enabled = (Dir.glob(file_name).size > 0)
#~   end
#~ end

#~ class Scene_Map < Scene_Base
#~   alias wora_nss_scemap_ter terminate
#~   def terminate
#~     Wora_NSS.shot(Wora_NSS::SAVE_PATH + 'temp')
#~     wora_nss_scemap_ter
#~   end
#~ end
#~ #======================================================================
#~ # END - NEO SAVE SYSTEM by Woratana
#~ #======================================================================
#===============================================================================
#
# Yanfly Engine RD - Menu System Options
# Last Date Updated: 2009.05.12
# Level: Easy, Normal
# 
# The "End Game" option is quite possibly the most useless function in RPG Maker
# VX games. Not only does it have little functionality but its functions can
# be reproduced by Alt+F4 and F12. This script replaces "End Game" with a new
# menu altogether and giving the player some familiar options seen in many of
# today's commercial RPG's such as changing window skins, adjust sound volume,
# turning off animations during battle, and the like.
#
#===============================================================================
# Updates:
# ----------------------------------------------------------------------------
# o 2009.05.12 - Auto-Dash update. If player holds down the dash button when
#                this option is enabled, the player will walk instead of dash.
# o 2009.05.09 - Compatibility update with Woratana's NeoMessage.
#                Compatibility update with Modern Algebra's ATS.
# o 2009.05.07 - Started script and finished.
#===============================================================================
# Instructions
#===============================================================================
#
# Input this script anywhere above Main. It's plug and play outside of changing
# a few variables and switches, which will be listed below:
#
# - If you have variables bound to variables 91, 92, 93, and 94, scroll down and
#   bind them to unused variables.
# - If you have switches bound to switches 91, 92, 93, 94, 95, or 96, scroll
#   down and bind them to unused switches.
#
# Then, download the windows pack, and create a "Windows" folder inside your
# Graphics folder. Input the windows pack there. You're all set to go.
#
#===============================================================================
#
# Compatibility
# - Works With: Woratana's NeoMessage
# - Works With: Modern Algebra's ATS
# - Alias: Game_Player: dash?
# - Alias: Window_Base: initialize
# - Alias: Scene_Battle: display_normal_animation
# - Overwrites: Scene_End: All of it
# - Overwrites: Vocab: game_end
#
#===============================================================================

$imported = {} if $imported == nil
$imported["MenuSystemOptions"] = true

module YE
  module SYSTEM
      
    # This changes the "End Game" string to a new string. This completely
    # overrides the default term from the database for a reason and that's
    # because this is adjustable from the title menu as well.
    TITLE = "System"
    
    #---------------------
    # Window Configuration
    #---------------------
    
    # This will affect what string data will appear for the window selection
    # portion of the system menu.
    WINDOW_HELP = "Select preferred window skin."
    WINDOW_SKIN = "Window Skin"
    
    # This sets the default window used when nothing is selected. This also
    # determines the window skin used at the title screen. Reference it to
    # the list below to determine which window skin. Don't make this 0.
    DEFAULT_WINDOW = 7
    
    # This determines the variable used to store the player's windowskin choice.
    WINDOW_VARIABLE = 91
    
#~     # This below determines what the variable refers to when it's used as
#~     # reference. Put your windows inside the Graphics/Windows folder. ID 0 will
#~     # automatically push back to the default window's ID.
#~     WINDOW_HASH ={
#~     # Window ID => Window Name
#~               1 => "Red",
#~               2 => "Orange",
#~               3 => "Yellow",
#~               4 => "Green",
#~               5 => "Cyan",
#~               6 => "Navy",
#~               7 => "Blue",
#~               8 => "Violet",
#~               9 => "Purple",
#~              10 => "Pink",
#~              11 => "Grey",
#~              12 => "Black",
#~     } # Do not remove this.
    
    #---------------------
    # Volume Configuration
    #---------------------
    
    # This will affect what string data will appear for the volume adjustment
    # portion of the system menu.
    BGM_HELP  = "Adjust BGM volume. Press L/R to mute."
    SFX_HELP  = "Adjust SFX volume. Press L/R to mute."
    BGS_HELP  = "Adjust BGS volume. Press L/R to mute."
    BGM_TITLE = "BGM Volume"
    SFX_TITLE = "SFX Volume"
    BGS_TITLE = "BGS Volume"
    VOL_MUTE  = "Mute"
    
    # These are the variables and switches that govern the sound effect volumes.
    # Note that for the variables, the higher they are, the lower the volume.
    BGM_VOLUME_VAR  = 92    # Variable
    SFX_VOLUME_VAR  = 93    # Variable
    BGS_VOLUME_VAR  = 94    # Variable
    BGM_MUTE_SWITCH = 92    # Switch
    SFX_MUTE_SWITCH = 93    # Switch
    BGS_MUTE_SWITCH = 94    # Switch
    
    # This adjusts the gradient colours for each of the volume controls.
    BGM_COLOUR1 = 30
    BGM_COLOUR2 = 31
    SFX_COLOUR1 = 28
    SFX_COLOUR2 = 29
    BGS_COLOUR1 = 20
    BGS_COLOUR2 = 21
    
    #---------------------
    # Battle Animations
    #---------------------
    
    # This will affect what string data will appear for the toggling of
    # battle animations portion of the system menu.
    ANI_TITLE = "Battle Animations"
    ANI_HELP  = "Toggles animations during battle."
    ANI_ON    = "Shown"
    ANI_OFF   = "Hidden"
    
    # This is the switch used to adjust battle animations. If it is off,
    # animations are enabled. If it is on, animations are disabled.
    ANI_SWITCH = 91
    
    #---------------------
    # Automatic Dashing
    #---------------------
    
    # This will affect what string data will appear for the toggling of
    # automatic dashing portion of the system menu.
    AUTO_DASH_TITLE = "Automatic Dash"
    AUTO_DASH_HELP  = "Toggles automatic dashing."
    AUTO_DASH_ON    = "Auto"
    AUTO_DASH_OFF   = "Hold"
    
    # This is the switch used to determine whether or not autodashing is on.
    AUTO_DASH_SWITCH = 95
    
    #---------------------
    # Instant Text
    #---------------------
    
    # This will affect what string data will appear for the instant text
    # portion of the system menu.
    INSTANT_TEXT_TITLE = "Instant Text"
    INSTANT_TEXT_HELP  = "Toggles instant text display."
    INSTANT_TEXT_ON    = "Instant"
    INSTANT_TEXT_OFF   = "Default"
    
    # This is the switch used to determine whether or not instant text is on.
    INSTANT_TEXT_SWITCH = 96
    
    #---------------------
    # Remaining Text
    #---------------------
    
    # This will affect what remaining string data is left for the system menu.
    RETURN_TO_TITLE   = "Return to Title Screen"
    RETURN_TITLE_HELP = "Return back to the title screen."
    RETURN_TO_MENU    = "Return to Main Menu"
    RETURN_MENU_HELP  = "Return back to the main menu."
      
  end # SYSTEM
end # YE

#===============================================================================
# Editting anything past this point may potentially result in causing computer
# damage, incontinence, explosion of user's head, coma, death, and/or halitosis.
# Therefore, edit at your own risk.
#===============================================================================

module Vocab
  def self.game_end
    return YE::SYSTEM::TITLE
  end
end

module Cache
  def self.windows(filename)
    load_bitmap("Graphics/Windows/", filename)
  end
end

module RPG
  
  class BGM < AudioFile
    def play
      if @name.empty?
        Audio.bgm_stop
        @@last = BGM.new
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGM_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
        end
        Audio.bgm_play("Audio/BGM/" + @name, vol, @pitch)
        @@last = self
      end
    end #Play
  end # BGM
  
  class ME < AudioFile
    def play
      if @name.empty?
        Audio.me_stop
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGM_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
        end
        Audio.me_play("Audio/ME/" + @name, vol, @pitch)
      end
    end
  end # ME
  
  class SE < AudioFile
    def play
      unless @name.empty?
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::SFX_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
        end
        Audio.se_play("Audio/SE/" + @name, vol, @pitch)
      end
    end
    def self.stop
      Audio.se_stop
    end
  end # SE
  
  class BGS < AudioFile
    def play
      if @name.empty?
        Audio.bgs_stop
        @@last = BGS.new
      else
        vol = @volume
        if $game_variables != nil
          vol *= 100 - $game_variables[YE::SYSTEM::BGS_VOLUME_VAR]
          vol /= 100
          vol = [[vol, 0].max, 100].min
          vol = 0 if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
        end
        Audio.bgs_play("Audio/BGS/" + @name, vol, @pitch)
        @@last = self
      end
    end
  end # BGS
  
end # RPG

#===============================================================================
# Game Player
#===============================================================================

class Game_Player < Game_Character
  
  #--------------------------------------------------------------------------
  # alias dash?
  #--------------------------------------------------------------------------
  alias dash_mso dash? unless $@
  def dash?
    if $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH]
      return false if @move_route_forcing
      return false if $game_map.disable_dash?
      return false if in_vehicle?
      return false if Input.press?(Input::A)
      return true
    else
      dash_mso
    end
  end
  
end

#~ #===============================================================================
#~ # Window
#~ #===============================================================================

#~ class Window
#~   
#~   #--------------------------------------------------------------------------
#~   # update windowskin
#~   #--------------------------------------------------------------------------
#~   def update_windowskin
#~     if $game_variables != nil
#~       winvar = YE::SYSTEM::WINDOW_VARIABLE
#~       if $game_variables[winvar] == 0
#~         $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
#~       elsif !YE::SYSTEM::WINDOW_HASH.include?($game_variables[winvar])
#~         $game_variables[winvar] = YE::SYSTEM::DEFAULT_WINDOW
#~       end
#~       mso_windowskin = YE::SYSTEM::WINDOW_HASH[$game_variables[winvar]]
#~     else
#~       mso_windowskin = YE::SYSTEM::WINDOW_HASH[YE::SYSTEM::DEFAULT_WINDOW]
#~     end
#~     self.windowskin = Cache.windows(mso_windowskin)
#~   end
#~   
#~ end

#~ #===============================================================================
#~ # Window Base
#~ #===============================================================================

#~ class Window_Base < Window
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_window_mso initialize unless $@
#~   def initialize(x, y, width, height)
#~     initialize_window_mso(x, y, width, height)
#~     self.update_windowskin
#~   end
#~   
#~ end

#===============================================================================
# Window Message
#===============================================================================

class Window_Message < Window_Selectable
  
  #--------------------------------------------------------------------------
  # alias update show fast
  #--------------------------------------------------------------------------
  alias update_show_fast_mso update_show_fast unless $@
  def update_show_fast
    if $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH]
      if self.pause or self.openness < 255
        @show_fast = false
      else
        @show_fast = true
      end
      if @show_fast and @wait_count > 0
        @wait_count -= 1
      end
    else
      update_show_fast_mso
    end
  end

#~ if $worale != nil
#~   if $worale["NMS"]
#~   #--------------------------------------------------------------------------
#~   # alias draw_name
#~   #--------------------------------------------------------------------------
#~   alias draw_name_mso draw_name unless $@
#~   def draw_name(name, x, y)
#~     draw_name_mso(name, x, y)
#~     @namebox.update_windowskin
#~   end
#~   end
#~ end
  
end
#~
#~ #===============================================================================
#~ # Window System
#~ #===============================================================================

#~ class Window_System < Window_Selectable
#~   
#~   #--------------------------------------------------------------------------
#~   # Initialize
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 56, 544, 360)
#~     @column_max = 1
#~     self.index = 0
#~     self.active = true
#~     refresh
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     @data = []
#~     @data.push(0) # Window Skins
#~     @data.push(1) # Sound Volume/Sound Mute
#~     @data.push(2) # BGM Volume/BGM Mute
#~     @data.push(3) # Ambience Volume/Ambience Mute
#~     @data.push(4) # Battle Animations
#~     @data.push(5) # Auto-Dash
#~     @data.push(6) # Instant Text
#~     @data.push(7) # Return to Title
#~     @data.push(8) # Return to Menu
#~     @item_max = @data.size
#~     self.contents.clear
#~     for i in 0..@item_max
#~       self.contents.font.color.alpha = 255
#~       draw_item(i)
#~     end
#~     #---
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Draw Item
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     sw = self.width - 32
#~     dw = sw
#~     #---
#~     case index
#~     when 0
#~       dx = 0
#~       dy = 0
#~       text = YE::SYSTEM::WINDOW_SKIN
#~       self.contents.draw_text(dx, dy, dw, WLH, text, 1)
#~       winvar = $game_variables[YE::SYSTEM::WINDOW_VARIABLE]
#~       text = YE::SYSTEM::WINDOW_HASH[winvar - 2]
#~       self.contents.draw_text(dx + dw * 0/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar - 1]
#~       self.contents.draw_text(dx + dw * 1/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar]
#~       self.contents.draw_text(dx + dw * 2/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar + 1]
#~       self.contents.draw_text(dx + dw * 3/5, dy + WLH, dw/5, WLH, text, 1)
#~       text = YE::SYSTEM::WINDOW_HASH[winvar + 2]
#~       self.contents.draw_text(dx + dw * 4/5, dy + WLH, dw/5, WLH, text, 1)
#~     when 1
#~       dx = 0
#~       dy = WLH * 2
#~       text = YE::SYSTEM::BGM_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 2
#~       dx = 0
#~       dy = WLH * 4
#~       text = YE::SYSTEM::SFX_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 3
#~       dx = 0
#~       dy = WLH * 6
#~       text = YE::SYSTEM::BGS_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/3 - 20, WLH*2, text, 0)
#~     when 4
#~       dx = 0
#~       dy = WLH * 8
#~       text = YE::SYSTEM::ANI_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::ANI_SWITCH]
#~         en1 = false
#~         en2 = true
#~       else
#~         en1 = true
#~         en2 = false
#~       end
#~       text1 = YE::SYSTEM::ANI_ON
#~       text2 = YE::SYSTEM::ANI_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 5
#~       dx = 0
#~       dy = WLH * 9
#~       text = YE::SYSTEM::AUTO_DASH_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH]
#~         en1 = true
#~         en2 = false
#~       else
#~         en1 = false
#~         en2 = true
#~       end
#~       text1 = YE::SYSTEM::AUTO_DASH_ON
#~       text2 = YE::SYSTEM::AUTO_DASH_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 6
#~       dx = 0
#~       dy = WLH * 10
#~       text = YE::SYSTEM::INSTANT_TEXT_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw/2 - 20, WLH, text, 0)
#~       if $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH]
#~         en1 = true
#~         en2 = false
#~       else
#~         en1 = false
#~         en2 = true
#~       end
#~       text1 = YE::SYSTEM::INSTANT_TEXT_ON
#~       text2 = YE::SYSTEM::INSTANT_TEXT_OFF
#~       self.contents.font.color.alpha = en1 ? 255 : 128
#~       self.contents.draw_text(sw*1/2, dy, dw/4, WLH, text1, 1)
#~       self.contents.font.color.alpha = en2 ? 255 : 128
#~       self.contents.draw_text(sw*3/4, dy, dw/4, WLH, text2, 1)
#~     #---
#~     when 7
#~       dx = 0
#~       dy = WLH * 11
#~       text = YE::SYSTEM::RETURN_TO_TITLE
#~       self.contents.draw_text(dx + 20, dy, dw - 20, WLH, text, 0)
#~     #---
#~     when 8
#~       dx = 0
#~       dy = WLH * 12
#~       text = YE::SYSTEM::RETURN_TO_MENU
#~       self.contents.draw_text(dx + 20, dy, dw - 20, WLH, text, 0)
#~     end
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Update Cursor
#~   #--------------------------------------------------------------------------
#~   def update_cursor
#~     if @index < 0
#~       self.cursor_rect.empty
#~     elsif @index < 4
#~       self.cursor_rect.set(0, @index * 48, self.width - 32, 48)
#~     else
#~       self.cursor_rect.set(0, @index * 24 + 96, self.width - 32, 24)
#~     end
#~   end
#~   
#~ end

#~ #===============================================================================
#~ # Window Volume
#~ #===============================================================================

#~ class Window_Volume < Window_Base
#~   
#~   #--------------------------------------------------------------------------
#~   # initialize
#~   #--------------------------------------------------------------------------
#~   def initialize(wx, wy, ww, wh, var)
#~     super(wx, wy, ww, wh)
#~     @var = var
#~     if @var == YE::SYSTEM::BGM_VOLUME_VAR
#~       @gc1 = text_color(YE::SYSTEM::BGM_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::BGM_COLOUR2)
#~       @mute = YE::SYSTEM::BGM_MUTE_SWITCH
#~     elsif @var == YE::SYSTEM::SFX_VOLUME_VAR
#~       @gc1 = text_color(YE::SYSTEM::SFX_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::SFX_COLOUR2)
#~       @mute = YE::SYSTEM::SFX_MUTE_SWITCH
#~     else
#~       @gc1 = text_color(YE::SYSTEM::BGS_COLOUR1)
#~       @gc2 = text_color(YE::SYSTEM::BGS_COLOUR2)
#~       @mute = YE::SYSTEM::BGS_MUTE_SWITCH
#~     end
#~     self.opacity = 0
#~     refresh
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     self.contents.clear
#~     sw = self.width - 32
#~     self.contents.fill_rect(0, 14, sw-80, 20, gauge_back_color)
#~     gw = sw-84
#~     gw *= 100 - $game_variables[@var]
#~     gw /= 100
#~     gw = [[gw, 0].max, sw-84].min
#~     self.contents.gradient_fill_rect(2, 16, gw, 16, @gc1, @gc2)
#~     if $game_switches[@mute]
#~       text = YE::SYSTEM::VOL_MUTE
#~     else
#~       text = sprintf("%d%%", 100 - $game_variables[@var])
#~     end
#~     self.contents.draw_text(sw-76, 0, 76, WLH*2, text, 0)
#~   end
#~   
#~ end
#~
#~ #===============================================================================
#~ # Modern Algebra ATS Compatibility
#~ #===============================================================================

#~ class Window_FaceBox < Window_Base
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_fb_mso initialize unless $@
#~   def initialize
#~     initialize_fb_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_NameBox < Window_Base
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_nb_mso initialize unless $@
#~   def initialize(string = '')
#~     initialize_nb_mso(string)
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_ChoiceBox < Window_Command 
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_cb_mso initialize unless $@
#~   def initialize
#~     initialize_cb_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#~ class Window_Message < Window_Selectable
#~ unless method_defined?(:initialize)
#~   
#~   #--------------------------------------------------------------------------
#~   # alias initialize
#~   #--------------------------------------------------------------------------
#~   alias initialize_wm_mso initialize unless $@
#~   def initialize
#~     initialize_wm_mso
#~     self.update_windowskin
#~   end
#~   
#~ end
#~ end

#===============================================================================
# Scene_Battle
#===============================================================================

class Scene_Battle < Scene_Base
  
  #--------------------------------------------------------------------------
  # alias display_normal_animation
  #--------------------------------------------------------------------------
  alias display_normal_animation_mso display_normal_animation unless $@
  def display_normal_animation(targets, animation_id, mirror = false)
    return if $game_switches[YE::SYSTEM::ANI_SWITCH]      
    display_normal_animation_mso(targets, animation_id, mirror)
  end
  
end

#~ #===============================================================================
#~ # Scene_End
#~ #===============================================================================

#~ class Scene_End < Scene_Base

#~   #--------------------------------------------------------------------------
#~   # Start processing
#~   #--------------------------------------------------------------------------
#~   def start
#~     super
#~     create_menu_background
#~     @help_window = Window_Base.new(0, 0, 544, 56)
#~     @help_window.contents.clear
#~     #---
#~     text = YE::SYSTEM::WINDOW_HELP
#~     @help_window.contents.draw_text(4,  0, 504, 24, text, 0)
#~     @system_window = Window_System.new
#~     var = YE::SYSTEM::BGM_VOLUME_VAR
#~     @bgm_vol_window = Window_Volume.new(160, 104, 384, 80, var)
#~     var = YE::SYSTEM::SFX_VOLUME_VAR
#~     @sfx_vol_window = Window_Volume.new(160, 152, 384, 80, var)
#~     var = YE::SYSTEM::BGS_VOLUME_VAR
#~     @bgs_vol_window = Window_Volume.new(160, 200, 384, 80, var)
#~     #---
#~     @last_index = 100
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Post-Start Processing
#~   #--------------------------------------------------------------------------
#~   def post_start
#~     super
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Pre-termination Processing
#~   #--------------------------------------------------------------------------
#~   def pre_terminate
#~     super
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Termination Processing
#~   #--------------------------------------------------------------------------
#~   def terminate
#~     super
#~     @help_window.dispose
#~     @system_window.dispose
#~     @bgm_vol_window.dispose
#~     @sfx_vol_window.dispose
#~     @bgs_vol_window.dispose
#~     dispose_menu_background
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Update Help
#~   #--------------------------------------------------------------------------
#~   def update_help
#~     @help_window.contents.clear
#~     case @system_window.index
#~     when 0; text = YE::SYSTEM::WINDOW_HELP
#~     when 1; text = YE::SYSTEM::BGM_HELP
#~     when 2; text = YE::SYSTEM::SFX_HELP
#~     when 3; text = YE::SYSTEM::BGS_HELP
#~     when 4; text = YE::SYSTEM::ANI_HELP
#~     when 5; text = YE::SYSTEM::AUTO_DASH_HELP
#~     when 6; text = YE::SYSTEM::INSTANT_TEXT_HELP
#~     when 7; text = YE::SYSTEM::RETURN_TITLE_HELP
#~     when 8; text = YE::SYSTEM::RETURN_MENU_HELP
#~     end
#~     @help_window.contents.draw_text(4,  0, 504, 24, text, 0)
#~   end
#~   
#~   #--------------------------------------------------------------------------
#~   # Frame Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     update_menu_background
#~     @system_window.update
#~     
#~     if @last_index != @system_window.index
#~       @last_index = @system_window.index
#~       update_help
#~     end
#~     
#~     if Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       return_scene
#~     else
#~       #---
#~       if Input.repeat?(Input::LEFT) and @system_window.index == 0
#~         $game_variables[YE::SYSTEM::WINDOW_VARIABLE] -= 1
#~         if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] == 0
#~           $game_variables[YE::SYSTEM::WINDOW_VARIABLE] = 1
#~         else
#~           Sound.play_cursor
#~         end
#~         @system_window.refresh
#~         @system_window.update_windowskin
#~         @help_window.update_windowskin
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 0
#~         $game_variables[YE::SYSTEM::WINDOW_VARIABLE] += 1
#~         if $game_variables[YE::SYSTEM::WINDOW_VARIABLE] >
#~         YE::SYSTEM::WINDOW_HASH.size
#~           $game_variables[YE::SYSTEM::WINDOW_VARIABLE] =
#~           YE::SYSTEM::WINDOW_HASH.size
#~         else
#~           Sound.play_cursor
#~         end
#~         @system_window.refresh
#~         @system_window.update_windowskin
#~         @help_window.update_windowskin
#~       #---
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 1
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 1
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::BGM_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::L) and @system_window.index == 1
#~         if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::R) and @system_window.index == 1
#~         if $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGM_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgm_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 2
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @sfx_vol_window.refresh
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 2
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::SFX_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @sfx_vol_window.refresh
#~       elsif Input.trigger?(Input::L) and @system_window.index == 2
#~         if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @sfx_vol_window.refresh
#~       elsif Input.trigger?(Input::R) and @system_window.index == 2
#~         if $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::SFX_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @sfx_vol_window.refresh
#~       elsif Input.repeat?(Input::LEFT) and @system_window.index == 3
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] += 10
#~         else
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] += 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] >= 100
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] = 100
#~         end
#~         Sound.play_cursor
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.repeat?(Input::RIGHT) and @system_window.index == 3
#~         if Input.press?(Input::A)
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] -= 10
#~         else
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] -= 1
#~         end
#~         if $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] <= 0
#~           $game_variables[YE::SYSTEM::BGS_VOLUME_VAR] = 0
#~         end
#~         Sound.play_cursor
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::L) and @system_window.index == 3
#~         if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::R) and @system_window.index == 3
#~         if $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH]
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = false
#~         else
#~           $game_switches[YE::SYSTEM::BGS_MUTE_SWITCH] = true
#~         end
#~         Sound.play_decision
#~         @bgs_vol_window.refresh
#~         RPG::BGM.last.play
#~         RPG::BGS.last.play
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 4
#~         $game_switches[YE::SYSTEM::ANI_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 4
#~         $game_switches[YE::SYSTEM::ANI_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 5
#~         $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 5
#~         $game_switches[YE::SYSTEM::AUTO_DASH_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::LEFT) and @system_window.index == 6
#~         $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH] = true
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::RIGHT) and @system_window.index == 6
#~         $game_switches[YE::SYSTEM::INSTANT_TEXT_SWITCH] = false
#~         Sound.play_decision
#~         @system_window.refresh
#~       elsif Input.trigger?(Input::C) and @system_window.index == 7
#~         Sound.play_decision
#~         RPG::BGM.fade(800)
#~         RPG::BGS.fade(800)
#~         RPG::ME.fade(800)
#~         $scene = Scene_Title.new
#~         Graphics.fadeout(60)
#~       elsif Input.trigger?(Input::C) and @system_window.index == 8
#~         Sound.play_cancel
#~         return_scene
#~       end
#~       #---
#~     end
#~   end
#~   
#~ end
#~
#===============================================================================
#
# END OF FILE
#
#===============================================================================
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_
#_/           ◆         Plot Summary - KGC_Outline         ◆
#_/           ◇          Last Update: 2008/07/27           ◇
#_/           ◆   Translated and Ported by Mr. Anonymous   ◆
#_/-----------------------------------------------------------------------------
#_/  Provides the function to show "Outline".
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_

#==============================================================================#
#                             ★ Customization ★                                #
#==============================================================================#

module KGC
  module Outline
  #               ◆ Plot Summary Background Transparancy ◆
  OLINE_BACK_TRANSPARENT = false
  #                           ◆ Scroll Speed ◆
  OLINE_SCROLL_SPEED = 8

  #                   ◆ Draw A Serial Number Toggle ◆
  OLINE_SERIAL_NUMBER = false
  #                     ◆ Serial Number of Digits ◆
  OLINE_SERIAL_NUMBER_DIGITS = 3

  #                 ◆ Disabled Plot Summary Title Text ◆
  OLINE_DISABLED_TITLE = " - - - - - - - - "
  #                 ◆ Hide Disabled Plot Summary Toggle ◆
  OLINE_HIDE_DISABLED  = true

  #                   ◆ Completed Plot Summary Symbol ◆
  OLINE_COMPLETION_SYMBOL   = "*"
  #                   ◆ Incomplete Plot Summary Symbol ◆
  OLINE_INCOMPLETION_SYMBOL = "　"
  #            ◆ Outline Command for Main Command Menu Toggle ◆
  USE_MENU_OUTLINE_COMMAND = false
   #                  ◆ Outline Command Selection Text ◆
  VOCAB_MENU_OUTLINE = "Outline"
  
#~ #### OLINE_CONTENTS
#~ ### Contents of "Outline".
#~ #  << ["Title", ["Body", ...]], ... >>
#~ #  In the "Body", each line of the array creates one line in-game. 
#~ #    **** Control statement ****
#~ #  \\V[n]  : Variable of ID:n
#~ #  \\G     : Money
#~ #  \\N[n]  : Actor's name of ID:n
#~ #  \\EN[n] : Enemies' name of ID:n
#~ #  \\IN[n] : Item's name of ID:n
#~ #  \\WN[n] : Weapon's name of ID:n
#~ #  \\AN[n] : Armor's name of ID:n

#~   OLINE_CONTENTS = [
#~     ["Skills Menu Controls",  # No.0
#~       ["Here, I'll explain how to access certain menus:",
#~       "",
#~       "To access the Skill CP System window from the Skills Menu:",
#~       "Press the Z Button (V on Keyboard)",
#~       "Pressing Z again will take you to the EquipLearnSkill window.",
#~       "To return to the skills window, press Y (C on Keyboard)",
#~       "",
#~       "To access the EquipLearnSkill window from the Skills Menu:",
#~       "Press the Y Button.",
#~       "Pressing Y again will take you to the Skill CP System window.",
#~       "To return to the skills window, press Z.",
#~       "",
#~       "While in any of these menus, you can also use the L and R" +
#~       " buttons (Q and W on keyboard) to shift to the previous/next" +
#~       " actor.",]],
#~     ["To Acess DistributeParameter...", # No.1
#~       ["While on an actor's status screen, press the X Button (A on" +
#~        "the keyboard).",]],
#~   ]  # -- Don't delete this line! --
  end
end

#================================End Module====================================#

$imported = {} if $imported == nil
$imported["Outline"] = true

#==============================================================================
# ■ Module - KGC_Outline
#==============================================================================

module KGC::Commands
  module_function
  #--------------------------------------------------------------------------
  # ● Plot Summary Scene Calls
  #--------------------------------------------------------------------------
  def call_outline
    # Correct Player Position
    $game_player.straighten
    # Plot Summary Scene Call Script Method
    $scene = Scene_Outline.new(true)
  end
  #--------------------------------------------------------------------------
  # ● Plot Summary Enablement
  #     index : Plot Summary Number
  #     value : Enabled State (true | false)
  #--------------------------------------------------------------------------
  def set_outline_enabled(index, value = true)
    if $game_system.outline_enable == nil
      $game_system.outline_enable = []
    end
    $game_system.outline_enable[index] = value
  end
  #--------------------------------------------------------------------------
  # ● Completed Plot Summary
  #     index : Plot Summary Number
  #     value : Complete State (true | false)
  #--------------------------------------------------------------------------
  def set_outline_completed(index, value = true)
    if $game_system.outline_complete == nil
      $game_system.outline_complete = []
    end
    $game_system.outline_complete[index] = value
  end
#~   #--------------------------------------------------------------------------
#~   # ● Process Command Control
#~   #     string : A Processing String
#~   #--------------------------------------------------------------------------
#~   def apply_outline_control_statement(string)
#~     buf = string.dup
#~     buf.gsub!(/\\V\[(\d+)\]/i)  { $game_variables[$1.to_i].to_s }
#~     buf.gsub!(/\\G/i)           { $game_party.gold.to_s }
#~     buf.gsub!(/\\N\[(\d+)\]/i)  { $game_actors[$1.to_i].name }
#~     buf.gsub!(/\\EN\[(\d+)\]/i) { $data_enemies[$1.to_i].name }
#~     buf.gsub!(/\\IN\[(\d+)\]/i) { $data_items[$1.to_i].name }
#~     buf.gsub!(/\\WN\[(\d+)\]/i) { $data_weapons[$1.to_i].name }
#~     buf.gsub!(/\\AN\[(\d+)\]/i) { $data_armors[$1.to_i].name }
#~     return buf
#~   end
end

#=================================End Module===================================#

class Game_Interpreter
  include KGC::Commands
end

#==================================End Class===================================#

#==============================================================================
# ■ Vocab
#==============================================================================

module Vocab
  # Set new vocabulary for Outline
  def self.outline
    return KGC::Outline::VOCAB_MENU_OUTLINE
  end
end

#=================================End Module===================================#

#==============================================================================
# ■ Game_System
#==============================================================================

class Game_System
  attr_accessor :outline_enable, :outline_complete
  #--------------------------------------------------------------------------
  # ● Object initialization 
  #--------------------------------------------------------------------------
  alias initialize_KGC_Outline initialize
  def initialize
    initialize_KGC_Outline

    @outline_enable = []
    @outline_complete = []
  end
end

#==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_OutlineList
#~ #------------------------------------------------------------------------------
#~ # Plot Summary List Display Window
#~ #==============================================================================

#~ class Window_OutlineList < Window_Selectable
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(72, 16, 382, 382)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     self.index = 0
#~     self.z = 1000
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Selected Plot Contents
#~   #--------------------------------------------------------------------------
#~   def outline
#~     return @data[self.index]
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #--------------------------------------------------------------------------
#~   def refresh
#~     self.contents.dispose if self.contents != nil
#~     @data = []
#~     @data_index = []
#~     # Lists
#~     $game_system.outline_enable = [] if $game_system.outline_enable == nil
#~     $game_system.outline_complete = [] if $game_system.outline_complete == nil
#~     KGC::Outline::OLINE_CONTENTS.each_with_index { |oline, i|
#~       if $game_system.outline_enable[i]
#~         @data << OutlineList_Info.new(oline[0], oline[1], i)
#~       elsif !KGC::Outline::OLINE_HIDE_DISABLED
#~         @data << OutlineList_Info.new(KGC::Outline::OLINE_DISABLED_TITLE, nil, i)
#~       end
#~     }
#~     # Draw List
#~     @item_max = [@data.size, 1].max
#~     self.contents = Bitmap.new(self.width - 32, 32 * @item_max)
#~     if @data.size == 0
#~       @data << OutlineList_Info.new
#~     else
#~       @data.each_index { |i| draw_item(i) }
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Draw Items
#~   #--------------------------------------------------------------------------
#~   def draw_item(index)
#~     self.contents.fill_rect(0, 32 * index, self.width - 32, 32, Color.new(0, 0, 0, 0))
#~     # Generate Title
#~     text = ($game_system.outline_complete[@data[index].index] ?
#~       KGC::Outline::OLINE_COMPLETION_SYMBOL : KGC::Outline::OLINE_INCOMPLETION_SYMBOL) +
#~       (KGC::Outline::OLINE_SERIAL_NUMBER ? sprintf("%0*d : ",
#~       KGC::Outline::OLINE_SERIAL_NUMBER_DIGITS, @data[index].index + 1) : "") +
#~       KGC::Commands.apply_outline_control_statement(@data[index].title)
#~     # Set Color
#~     self.contents.font.color = $game_system.outline_enable[@data[index].index] ?
#~       normal_color : normal_color
#~     self.contents.draw_text(0, 24 * index, self.width - 32, 22, text)
#~   end
#~ end

#==============================================================================
# ■ OutlineList_Info
#------------------------------------------------------------------------------
#  Class to hold Plot Summary List Information
#==============================================================================

class OutlineList_Info
  attr_accessor :title, :contents, :index
  #--------------------------------------------------------------------------
  # ● Object initialization
  #--------------------------------------------------------------------------
  def initialize(title = "", contents = nil, index = 0)
    @title = title
    @contents = contents
    @index = index
  end
end

#==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_OutlineTitle
#~ #------------------------------------------------------------------------------
#~ # Plot Summary Title Window Display
#~ #==============================================================================

#~ class Window_OutlineTitle < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 0, 544, 64)
#~     self.contents = Bitmap.new(width - 32, height - 32)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #     text  : Visible Strings
#~   #--------------------------------------------------------------------------
#~   def refresh(text)
#~     self.contents.clear
#~     text2 = KGC::Commands::apply_outline_control_statement(text)
#~     self.contents.draw_text(0, 0, self.width - 32, 32, text2, 1)
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Window_Outline
#~ #------------------------------------------------------------------------------
#~ # 　 Plot (content) to display window.
#~ #==============================================================================

#~ class Window_Outline < Window_Base
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #--------------------------------------------------------------------------
#~   def initialize
#~     super(0, 64, 544, 352)
#~     self.back_opacity = 160 if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     self.active = false
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Refresh
#~   #     oline : Plot
#~   #--------------------------------------------------------------------------
#~   def refresh(oline = nil)
#~     self.oy = 0
#~     self.contents.dispose if self.contents != nil
#~     return if oline == nil
#~     # Draw Text 
#~     self.contents = Bitmap.new(self.width - 32, 32 * oline.size)
#~     oline.each_with_index { |l ,i|
#~       next if l == nil
#~       text = KGC::Commands::apply_outline_control_statement(l)
#~       self.contents.draw_text(0, i * 32, self.width - 32, 32, text)
#~     }
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     super
#~     # Scroll
#~     if self.active
#~       scroll_max = [self.contents.height - (self.height - 32), 0].max
#~       if Input.press?(Input::UP)
#~         self.oy = [self.oy - KGC::Outline::OLINE_SCROLL_SPEED, 0].max
#~       elsif Input.press?(Input::DOWN)
#~         self.oy = [self.oy + KGC::Outline::OLINE_SCROLL_SPEED, scroll_max].min
#~       elsif Input.repeat?(Input::L)
#~         self.oy = [self.oy - (self.height - 32), 0].max
#~       elsif Input.repeat?(Input::R)
#~         self.oy = [self.oy + (self.height - 32), scroll_max].min
#~       end
#~     end
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Scene_Outline
#~ #------------------------------------------------------------------------------
#~ # Plot Summary Scene Class  
#~ #==============================================================================

#~ class Scene_Outline
#~   #--------------------------------------------------------------------------
#~   # ● Object initialization
#~   #     map_call : Map call flag
#~   #--------------------------------------------------------------------------
#~   def initialize(map_call = false)
#~     @map_call = map_call
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Main Process
#~   #--------------------------------------------------------------------------
#~   def main
#~     # Screate Spriteset
#~     @spriteset = Spriteset_Map.new if KGC::Outline::OLINE_BACK_TRANSPARENT
#~     # Create Window
#~     @list_window = Window_OutlineList.new
#~     @title_window = Window_OutlineTitle.new
#~     @content_window = Window_Outline.new
#~     # Run Transition
#~     Graphics.transition
#~     # Loop Main
#~     loop {
#~       Graphics.update
#~       Input.update
#~       update
#~       if $scene != self
#~         break
#~       end
#~     }
#~     # Freeze Graphics
#~     Graphics.freeze
#~     # Dispose
#~     @list_window.dispose
#~     @title_window.dispose
#~     @content_window.dispose
#~     @spriteset.dispose if KGC::Outline::OLINE_BACK_TRANSPARENT
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update
#~   #--------------------------------------------------------------------------
#~   def update
#~     # Update Windows
#~     @list_window.update
#~     @title_window.update
#~     @content_window.update
#~     # Operate Active Window
#~     if @list_window.active
#~       update_list
#~     elsif @content_window.active
#~       update_content
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update Frame (List)
#~   #--------------------------------------------------------------------------
#~   def update_list
#~     # If B Button is Pressed 
#~     if Input.trigger?(Input::B)
#~       # Play cancel SE
#~       $data_system.sounds[2].play
#~       if @map_call
#~         # Call Map
#~         $scene = Scene_Map.new
#~       else
#~           $scene = Scene_Menu.new
#~       end
#~       return
#~     end
#~     # If C Button is Pressed 
#~     if Input.trigger?(Input::C)
#~       outline = @list_window.outline
#~       # If you cannot view...
#~       if outline.contents == nil
#~         # Play buzzer SE
#~         $data_system.sounds[3].play
#~         return
#~       end
#~       # Play decision SE
#~       $data_system.sounds[1].play
#~       # Update Plot Summary 
#~       @title_window.refresh(outline.title)
#~       @content_window.refresh(outline.contents)
#~       # Switch Window
#~       @list_window.active = false
#~       @list_window.z = 0
#~       @content_window.active = true
#~       @content_window.z = 1000
#~       return
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Frame Update (Text)
#~   #--------------------------------------------------------------------------
#~   def update_content
#~     # If B Button is Pressed 
#~     if Input.trigger?(Input::B)
#~       # Play cancel SE
#~       $data_system.sounds[2].play
#~       # Switch Window
#~       @list_window.active = true
#~       @list_window.z = 1000
#~       @content_window.active = false
#~       @content_window.z = 0
#~       return
#~     end
#~   end
#~ end

#~ #==================================End Class===================================#

#~ #==============================================================================
#~ # ■ Scene_Menu
#~ #==============================================================================

#~ class Scene_Menu < Scene_Base
#~   if KGC::Outline::USE_MENU_OUTLINE_COMMAND
#~   #--------------------------------------------------------------------------
#~   # ● Create command window
#~   #--------------------------------------------------------------------------
#~     alias create_command_window_KGC_Outline create_command_window
#~     def create_command_window
#~       create_command_window_KGC_Outline

#~       return if $imported["CustomMenuCommand"]

#~       @__command_outline_index =
#~         @command_window.add_command(Vocab.outline)
#~       @command_window.draw_item(@__command_outline_index)
#~       if @command_window.oy > 0
#~         @command_window.oy -= Window_Base::WLH
#~       end
#~       @command_window.index = @menu_index
#~     end
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● Update Command Selection
#~   #--------------------------------------------------------------------------
#~   alias update_command_selection_KGC_Outline update_command_selection
#~   def update_command_selection
#~     current_menu_index = @__command_outline_index
#~     call_outline_flag = false

#~     if Input.trigger?(Input::C)
#~       case @command_window.index
#~       when @__command_outline_index 
#~         call_outline_flag = true
#~       end
#~     end
#~     if call_outline_flag
#~       Sound.play_decision
#~       $scene = Scene_Outline.new(current_menu_index)
#~       return
#~     end

#~     update_command_selection_KGC_Outline
#~   end
#~ end

#~ #==================================End Class===================================#
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/
#_/    ◆         Battle Difficulty - KGC_BattleDifficulty        ◆ VX ◆
#_/    ◇                 Last Update: 2008/05/09                      ◇
#_/    ◆               Translation by Mr. Anonymous                   ◆
#_/----------------------------------------------------------------------------
#_/  This script adds battle difficulty settings to your game.
#_/============================================================================
#_/  Installation: Insert below KGC_ExtraDropItem and KGC_CustomMenuCommand.
#_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/

#==============================================================================#
#                            ★ Customization ★                                 #
#==============================================================================#

module KGC
module BattleDifficulty
  #                       ◆ Difficulty Variable ◆
  #  Change the variable the difficulty setting is stored in.
  DIFFICULTY_VARIABLE = 15

  #                           ◆ Difficulty ◆
  #  Difficulty Format:
  #   DIFFICULTY << {
  #     :name  => "Difficulty Name",
  #     :maxhp => MaxHP,
  #     :maxmp => MaxMP,
  #     :atk   => Attack,
  #     :def   => Defense,
  #     :spi   => Spirit,
  #     :agi   => Agility,
  #     :param => Attack ・ Defense ・ Spirit ・ Agility (Batch Specification),
  #     :hit   => Hit Ratio,
  #     :eva   => Evasion,
  #     :cri   => Critical,
  #     :exp   => Experience,
  #     :gold  => Gold,
  #     :drop  => Item Drop Rate,
  #   }
  #  Create by the format
  #  （:atk, :def, :spi, :agi (The :param field takes highest priority）
  #  The unit is a percentile of a each item.
  #  :name is not optional
  #  An omitted item is treated as a default of 100
  DIFFICULTY = [] # Do not remove or modify this line!
  # ～ Custom Difficulty Settings Inserted Below Here ～
  DIFFICULTY << {        # Difficulty Level: 0
    :name  => "Easy",
    :maxhp => 80,
    :maxmp => 80,
    :param => 80,
    :cri   => 50,
    :drop  => 90,
  }  # ← Do not remove!
  DIFFICULTY << {        # Difficulty Level: 1
    :name  => "Normal",
  }
  DIFFICULTY << {        # Difficulty Level: 2
    :name  => "Hard",
    :maxhp => 150,
    :maxmp => 130,
    :atk   => 120,
    :spi   => 120,
    :agi   => 110,
    :drop  => 120,
  }
  DIFFICULTY << {        # Difficulty Level: 3
    :name  => "Very Hard",
    :maxhp => 200,
    :maxmp => 180,
    :atk   => 150,
    :spi   => 150,
    :agi   => 130,
    :cri   => 120,
    :drop  => 140,
  }
  DIFFICULTY << {        # Difficulty Level: 4
    :name  => "Extreme",
    :maxhp => 300,
    :maxmp => 260,
    :atk   => 200,
    :spi   => 200,
    :agi   => 150,
    :cri   => 160,
    :drop  => 160,
  }
  DIFFICULTY << {        # Difficulty Level: 5
    :name  => "Legendary",
    :maxhp => 500,
    :maxmp => 400,
    :atk   => 300,
    :spi   => 300,
    :agi   => 180,
    :cri   => 200,
    :drop  => 200,
  }

  #                      ◆ Difficulty Initialization ◆
  #  DIFFICULTY Index
  #  By default, 1 = Normal
  INITIAL_DIFFICULTY = 1

  #                 ◆ Add Difficulty Command to Main Menu ◆
  #  This toggle enables/disables the difficulty command selection to be added 
  #   to the main command menu.
  USE_MENU_DIFFICULTY_COMMAND = false
end
end

#------------------------------------------------------------------------------#

$imported = {} if $imported == nil
$imported["BattleDifficulty"] = true

module KGC::BattleDifficulty
  # Parameters
  PARAMS = [
    :maxhp, :maxmp, :atk, :def, :spi, :agi,
    :hit, :eva, :cri, :exp, :gold, :drop
  ]

  module_function
  #--------------------------------------------------------------------------
  # ○ 難易度補正値作成
  #--------------------------------------------------------------------------
  def create_param_revs
    @@param_revs = []
    DIFFICULTY.each { |d|
      rev = {}
      rev[:name] = d[:name]
      # 一括指定を適用
      if d[:param] != nil
        rev[:atk] = rev[:def] = rev[:spi] = rev[:agi] = d[:param]
      end
      # パラメータ指定を適用
      PARAMS.each { |par|
        if d[par] != nil
          rev[par] = d[par]
        else
          rev[par] = 100 if rev[par] == nil
        end
      }
      # リストに追加
      @@param_revs << rev
    }
  end
  #--------------------------------------------------------------------------
  # ○ 難易度補正値取得
  #--------------------------------------------------------------------------
  def param_revs
    return @@param_revs
  end
  #--------------------------------------------------------------------------
  # ○ 難易度インデックス取得
  #--------------------------------------------------------------------------
  def get_index
    vid = DIFFICULTY_VARIABLE
    if $game_variables[vid] < 0 || DIFFICULTY.size <= $game_variables[vid]
      $game_variables[vid] = INITIAL_DIFFICULTY
    end
    return $game_variables[vid]
  end
  #--------------------------------------------------------------------------
  # ○ 難易度取得
  #--------------------------------------------------------------------------
  def get
    return @@param_revs[get_index]
  end
  #--------------------------------------------------------------------------
  # ○ 難易度変更
  #     index : 難易度インデックス
  #--------------------------------------------------------------------------
  def set(index)
    index = [[index, DIFFICULTY.size - 1].min, 0].max
    $game_variables[DIFFICULTY_VARIABLE] = index
  end

  create_param_revs
end

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ RPG::Enemy::DropItem
#==============================================================================

unless $@
class RPG::Enemy::DropItem
  #--------------------------------------------------------------------------
  # ● 出現率 1/N の分母 N
  #--------------------------------------------------------------------------
  alias denominator_KGC_BattleDifficulty denominator
  def denominator
    n = denominator_KGC_BattleDifficulty
    if n > 1
      n = [n * 100 / KGC::BattleDifficulty.get[:drop], 1].max
    end
    return n
  end

if method_defined?(:drop_prob)
  #--------------------------------------------------------------------------
  # ○ ドロップ率 (直接指定)
  #--------------------------------------------------------------------------
  alias drop_prob_KGC_BattleDifficulty drop_prob
  def drop_prob
    n = drop_prob_KGC_BattleDifficulty
    if n < 100 && 0 < n
      n = [[n * KGC::BattleDifficulty.get[:drop] / 100, 1].max, 100].min
    end
    return n
  end
end

end  # class
end  # unless $@

#★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Game_Enemy
#==============================================================================

class Game_Enemy < Game_Battler
  #--------------------------------------------------------------------------
  # ● 基本 MaxHP の取得
  #--------------------------------------------------------------------------
  alias base_maxhp_KGC_BattleDifficulty base_maxhp
  def base_maxhp
    n = base_maxhp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:maxhp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本 MaxMP の取得
  #--------------------------------------------------------------------------
  alias base_maxmp_KGC_BattleDifficulty base_maxmp
  def base_maxmp
    n = base_maxmp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:maxmp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本攻撃力の取得
  #--------------------------------------------------------------------------
  alias base_atk_KGC_BattleDifficulty base_atk
  def base_atk
    n = base_atk_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:atk] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本防御力の取得
  #--------------------------------------------------------------------------
  alias base_def_KGC_BattleDifficulty base_def
  def base_def
    n = base_def_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:def] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本精神力の取得
  #--------------------------------------------------------------------------
  alias base_spi_KGC_BattleDifficulty base_spi
  def base_spi
    n = base_spi_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:spi] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 基本敏捷性の取得
  #--------------------------------------------------------------------------
  alias base_agi_KGC_BattleDifficulty base_agi
  def base_agi
    n = base_agi_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:agi] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 命中率の取得
  #--------------------------------------------------------------------------
  alias hit_KGC_BattleDifficulty hit
  def hit
    n = hit_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:hit] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 回避率の取得
  #--------------------------------------------------------------------------
  alias eva_KGC_BattleDifficulty eva
  def eva
    n = eva_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:eva] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● クリティカル率の取得
  #--------------------------------------------------------------------------
  alias cri_KGC_BattleDifficulty cri
  def cri
    n = cri_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:cri] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● 経験値の取得
  #--------------------------------------------------------------------------
  alias exp_KGC_BattleDifficulty exp
  def exp
    n = exp_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:exp] / 100
    return n
  end
  #--------------------------------------------------------------------------
  # ● お金の取得
  #--------------------------------------------------------------------------
  alias gold_KGC_BattleDifficulty gold
  def gold
    n = gold_KGC_BattleDifficulty
    n = n * KGC::BattleDifficulty.get[:gold] / 100
    return n
  end
end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#~ #==============================================================================
#~ # ■ Window_Command
#~ #==============================================================================

#~ class Window_Command < Window_Selectable

#~ unless method_defined?(:add_command)
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを追加
#~   #    追加した位置を返す
#~   #--------------------------------------------------------------------------
#~   def add_command(command)
#~     @commands << command
#~     @item_max = @commands.size
#~     item_index = @item_max - 1
#~     refresh_command
#~     draw_item(item_index)
#~     return item_index
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドをリフレッシュ
#~   #--------------------------------------------------------------------------
#~   def refresh_command
#~     buf = self.contents.clone
#~     self.height = [self.height, row_max * WLH + 32].max
#~     create_contents
#~     self.contents.blt(0, 0, buf, buf.rect)
#~     buf.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを挿入
#~   #--------------------------------------------------------------------------
#~   def insert_command(index, command)
#~     @commands.insert(index, command)
#~     @item_max = @commands.size
#~     refresh_command
#~     refresh
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを削除
#~   #--------------------------------------------------------------------------
#~   def remove_command(command)
#~     @commands.delete(command)
#~     @item_max = @commands.size
#~     refresh
#~   end
#~ end

#~ unless method_defined?(:replace_command)
#~   #--------------------------------------------------------------------------
#~   # ○ コマンドを置換
#~   #--------------------------------------------------------------------------
#~   def replace_command(index, command, enabled = true)
#~     @commands[index] = command
#~     draw_item(index, enabled)
#~   end
#~ end

#~ end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#==============================================================================
# ■ Scene_Title
#==============================================================================

class Scene_Title < Scene_Base
  #--------------------------------------------------------------------------
  # ● 各種ゲームオブジェクトの作成
  #--------------------------------------------------------------------------
  alias create_game_objects_KGC_BattleDifficulty create_game_objects
  def create_game_objects
    create_game_objects_KGC_BattleDifficulty

    # 難易度を初期化
    variable_id = KGC::BattleDifficulty::DIFFICULTY_VARIABLE
    $game_variables[variable_id] = KGC::BattleDifficulty::INITIAL_DIFFICULTY
  end
end

#~ #★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★

#~ #==============================================================================
#~ # ■ Scene_Menu
#~ #==============================================================================

#~ class Scene_Menu < Scene_Base
#~   #--------------------------------------------------------------------------
#~   # ● コマンドウィンドウの作成
#~   #--------------------------------------------------------------------------
#~   alias create_command_window_KGC_BattleDifficulty create_command_window
#~   def create_command_window
#~     create_command_window_KGC_BattleDifficulty

#~     create_difficulty_window

#~     return unless KGC::BattleDifficulty::USE_MENU_DIFFICULTY_COMMAND
#~     return if $imported["CustomMenuCommand"]

#~     @__command_set_difficulty_index =
#~       @command_window.add_command(KGC::BattleDifficulty.get[:name])
#~     if @command_window.oy > 0
#~       @command_window.oy -= Window_Base::WLH
#~     end
#~     @command_window.index = @menu_index
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択ウィンドウの作成
#~   #--------------------------------------------------------------------------
#~   def create_difficulty_window
#~     commands = []
#~     KGC::BattleDifficulty::param_revs.each { |d|
#~       commands << d[:name]
#~     }
#~     @difficulty_window = Window_Command.new(160, commands)
#~     @difficulty_window.x = @command_window.width - 16
#~     @difficulty_window.z = 1000
#~     @difficulty_window.active = false
#~     @difficulty_window.openness = 0
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● 終了処理
#~   #--------------------------------------------------------------------------
#~   alias terminate_KGC_BattleDifficulty terminate
#~   def terminate
#~     terminate_KGC_BattleDifficulty

#~     @difficulty_window.dispose
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● フレーム更新
#~   #--------------------------------------------------------------------------
#~   alias update_KGC_BattleDifficulty update
#~   def update
#~     @difficulty_window.update
#~     if @difficulty_window.active
#~       update_KGC_BattleDifficulty

#~       update_difficulty_selection
#~       return
#~     end

#~     update_KGC_BattleDifficulty
#~   end
#~   #--------------------------------------------------------------------------
#~   # ● コマンド選択の更新
#~   #--------------------------------------------------------------------------
#~   alias update_command_selection_KGC_BattleDifficulty update_command_selection
#~   def update_command_selection
#~     call_ap_viewer_flag = false
#~     if Input.trigger?(Input::C)
#~       case @command_window.index
#~       when @__command_set_difficulty_index  # 難易度設定
#~         call_set_difficulty_flag = true
#~       end
#~     end

#~     # 難易度設定に移行
#~     if call_set_difficulty_flag
#~       Sound.play_decision
#~       start_difficulty_selection
#~       return
#~     end

#~     update_command_selection_KGC_BattleDifficulty
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の開始
#~   #--------------------------------------------------------------------------
#~   def start_difficulty_selection
#~     @command_window.active = false
#~     dy = @command_window.cursor_rect.y
#~     limit_y = Graphics.height - @difficulty_window.height
#~     @difficulty_window.y = [[dy, limit_y].min, 0].max
#~     @difficulty_window.active = true
#~     @difficulty_window.index = KGC::BattleDifficulty.get_index
#~     @difficulty_window.open
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の終了
#~   #--------------------------------------------------------------------------
#~   def end_difficulty_selection
#~     @command_window.active = true
#~     @difficulty_window.active = false
#~     @difficulty_window.close
#~   end
#~   #--------------------------------------------------------------------------
#~   # ○ 難易度選択の更新
#~   #--------------------------------------------------------------------------
#~   def update_difficulty_selection
#~     if Input.trigger?(Input::B)
#~       Sound.play_cancel
#~       end_difficulty_selection
#~     elsif Input.trigger?(Input::C)
#~       Sound.play_decision
#~       # 難易度を変更
#~       KGC::BattleDifficulty.set(@difficulty_window.index)
#~       @command_window.replace_command(@__command_set_difficulty_index,
#~         KGC::BattleDifficulty.get[:name])
#~       end_difficulty_selection
#~     end
#~   end
#~ end

