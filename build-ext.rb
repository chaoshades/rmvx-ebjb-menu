module EBJB_Menu_Ext
  # Build filename
  FINAL   = "build/EBJB_Menu_Ext.rb"
  # Source files
  TARGETS = [
    "src/External Scripts/Neo Save System V.rb",
    "src/External Scripts/YERD_MenuSystem.rb",
    "src/External Scripts/KGC_Outline.rb",
    "src/External Scripts/KGC_BattleDifficulty.rb",
  ]
end

def ebjb_build_ext
  final = File.new(EBJB_Menu_Ext::FINAL, "w+")
  EBJB_Menu_Ext::TARGETS.each { |file|
    src = File.open(file, "r+")
    final.write(src.read + "\n")
    src.close
  }
  final.close
end

ebjb_build_ext()