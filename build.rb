module EBJB_Menu
  # Build filename
  FINAL   = "build/EBJB_Menu.rb"
  # Source files
  TARGETS = [
	"src/Script_Header.rb",
    "src/Menu_Config.rb",
    "src/Game Objects/Game_Map.rb",
    "src/Game Objects/Game_Actor.rb",
    "src/Game Objects/Game_Party.rb",
    "src/Game Objects/Game_Temp.rb",
    "src/Scenes/Scene_Menu.rb",
    "src/Scenes/Scene_Status.rb",
    "src/Scenes/Scene_Item.rb",
    "src/Scenes/Scene_Battle.rb",
    "src/Scenes/Scene_Equip.rb",
    "src/Scenes/Scene_Skill.rb",
    "src/Scenes/Scene_File.rb",
    "src/Scenes/Scene_Title.rb",
    "src/Scenes/Scene_Map.rb",
    "src/Scenes/Scene_End.rb",
    "src/Scenes/Scene_Outline.rb",
    "src/User Interface/Font.rb",
    "src/User Interface/Color.rb",
    "src/User Interface/Vocab.rb",
    "src/Windows/Window_Party_Status.rb",
    "src/Windows/Window_Menu_Info.rb",
    "src/Windows/Window_Status.rb",
    "src/Windows/Window_Char_Image.rb",
    "src/Windows/Window_Status_Equip.rb",
    "src/Windows/Window_Char_Info.rb",
    "src/Windows/Window_Item.rb",
    "src/Windows/Window_Dataviews.rb",
    "src/Windows/Window_Skill_Status.rb",
    "src/Windows/Window_Skill.rb",
    "src/Windows/Window_Equip_Compare_Status.rb",
    "src/Windows/Window_Equip_Item.rb",
    "src/Windows/Window_Slot_List.rb",
    "src/Windows/Window_Slot_Details.rb",
    "src/Windows/Window_Optimize_Modes.rb",
    "src/Windows/Window_System.rb",
    "src/Windows/Window_Base.rb",
    "src/Windows/Window_Outline.rb",
    "src/Windows/Window_Outline_Title.rb",
    "src/Windows/Window_Outline_List.rb",
    "src/User Controls/UCPartyCharStatus.rb",
    "src/User Controls/UCCompareCharStatus.rb",
    "src/User Controls/UCCompareStat.rb",
    "src/User Controls/UCCharStatus.rb",
    "src/User Controls/UCEquipItem.rb",
    "src/User Controls/UCItem.rb",
    "src/User Controls/UCSkill.rb",
    "src/User Controls/UCSaveCharStatus.rb",
    "src/User Controls/UCVolumeControl.rb",
    "src/Misc Objects/SaveData.rb",
  ]
end

def ebjb_build
  final = File.new(EBJB_Menu::FINAL, "w+")
  EBJB_Menu::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build()