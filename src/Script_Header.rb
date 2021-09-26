################################################################################
#                   EBJB Custom Menu System - EBJB_Menu               #   VX   #
#                          Last Update: 2012/03/15                    ##########
#                         Creation Date: 2011/06/25                            #
#                          Author : ChaosHades                                 #
#     Source :                                                                 #
#     http://www.google.com                                                    #
#------------------------------------------------------------------------------#
#  Contains custom scripts changing the main windows of the menu in your game  #
#  and new features :                                                          #
#  - Save & Load game with a more detailed view (based on Neo Save System V)   #
#  - System window for different in-game options (based on YERD_MenuSystem     #
#    and KGC_Outline)                                                          #
#  - Sorting by different attribute of an item in the inventory                #
#  - Show the newest items in the inventory                                    #
#  - More detailed description of the new equip is shown in the Equip window   #
#  - More detailed info are shown when browsing items or skills                #
#==============================================================================#
#                         ** Instructions For Usage **                         #
#  There are settings that can be configured in the Menu_Config class. For     #
#  more info on what and how to adjust these settings, see the documentation   #
#  in the class.                                                               #
#==============================================================================#
#                                ** Examples **                                #
#  See the documentation in each classes.                                      #
#==============================================================================#
#                           ** Installation Notes **                           #
#  Copy this script in the Materials section                                   #
#==============================================================================#
#                             ** Compatibility **                              #
#  Alias: Game_Map - initialize                                                #
#  Alias: Game_Party - initialize, gain_item                                   #
#  Alias: Game_Temp - initialize                                               #
#  Alias: Scene_File - write_save_data                                         #
#  Alias: Window_Base - initialize                                             #
#  Alias: BaseItemComparer - compare                                           #
#  Alias: UsableItemFilter - apply                                             #
################################################################################

$imported = {} if $imported == nil
$imported["EBJB_Menu"] = true
