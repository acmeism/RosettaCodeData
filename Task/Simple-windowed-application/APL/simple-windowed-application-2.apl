#!/usr/local/bin/apl --script --OFF

⍝ Some GTK API consts for readability
⍝ event poll type for X ← ⎕gtk
Blocking ← 1
Nonblocking ← 2

∇Z←get_NAME_and_POSITION;GUI_path;CSS_path;Handle
  GUI_path ← '/home/me/GNUAPL/workspaces/my-application.glade'
  CSS_path ← '/home/me/GNUAPL/workspaces/my-application.css'
  Handle ← CSS_path ⎕GTK GUI_path

  ⍝H_ID ← Handle, 'entry1'		⍝ Position field
  ⍝'<enter name>' ⎕gtk[H_ID] "set_text"	⍝ pre-fill entry

  ⊣⎕gtk Blocking	⍝ Wait for click event

  Z ← ⊂1↓⎕gtk[Handle, 'entry1'] "get_text"
  Z ← Z,⊂1↓⎕gtk[Handle, 'entry2'] "get_text"
  ⊣Handle ⎕gtk 0
∇

⍝ Launch GUI application
get_NAME_and_POSITION
