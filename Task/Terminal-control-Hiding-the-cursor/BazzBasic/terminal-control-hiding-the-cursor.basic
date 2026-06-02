' ============================================
' https://rosettacode.org/wiki/Terminal_control/Hiding_the_cursor
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================
' ANSI/VT escape sequences control cursor visibility.
' They are sent directly to the terminal via PRINT CHR(27) + "...";
' No external tools needed.
'
' ESC[?25l  —  hide cursor
' ESC[?25h  —  show cursor
'
' Requires Windows 10+ with Virtual Terminal Processing enabled,
' which is the default in Windows Terminal and modern cmd.exe.

LET HIDE_CURSOR# = CHR(27) + "[?25l"
LET SHOW_CURSOR# = CHR(27) + "[?25h"

[inits]
    LET wkv$   ' WAITKEY return value

[main]
    PRINT HIDE_CURSOR#;
    PRINT "Cursor is now hidden. Press any key to reveal it..."
    LET wkv$ = WAITKEY()

    PRINT SHOW_CURSOR#;
    PRINT "Cursor is visible again."
END
