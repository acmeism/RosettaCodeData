' ============================================
' https://rosettacode.org/wiki/Create_a_file
' BazzBasic: https://github.com/EkBass/BazzBasic
' ============================================

[inits]
    ' No filesystem root built-in BazzBasic, so I use creative way to get it
    LET DRIVE_ROOT# = MID(SHELL("echo %CD%"), 1, 3) ' "C:\" or "D:\" or...

[main]
    ' Create in current directory
    FileWrite "output.txt", ""
    FileWrite "docs\\placeholder.txt", ""   ' FileWrite auto-creates the directory


    ' Create in filesystem root
    FileWrite DRIVE_ROOT# + "\\output.txt", ""
    FileWrite DRIVE_ROOT# + "\\docs\\placeholder.txt", ""

    PRINT "Done."
END
