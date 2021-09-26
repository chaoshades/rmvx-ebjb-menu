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