on runGame(seed, dimensions, maxGenerations)
    -- Create an RTF file set up for Menlo-Regular 12pt, half spacing, and a reasonable window size.
    set fontName to "Menlo-Regular"
    set fontSize to 12
    set viewScale to fontSize * 12.4 -- Seems to work well.
    set {w, h} to dimensions

    set RTFHeaders to "{\\rtf1\\ansi\\ansicpg1252\\cocoartf1671\\cocoasubrtf600
{\\fonttbl\\f0\\fnil\\fcharset0 " & fontName & ";}
{\\colortbl;\\red255\\green255\\blue255;}
{\\*\\expandedcolortbl;;}
\\margl1440\\margr1440\\vieww" & (w * viewScale as integer) & "\\viewh" & ((h + 1) * viewScale as integer) & "\\viewkind0
\\pard\\sl120\\slmult1\\pardirnatural\\partightenfactor0
\\f0\\fs" & (fontSize * 2) & " \\cf0  }" -- Contains a space as body text for TextEdit to see as an 'attribute run'.
    set RTFFile to ((path to temporary items as text) & "Conway's Game of Life.rtf") as «class furl»
    set fRef to (open for access RTFFile with write permission)
    try
        set eof fRef to 0
        write RTFHeaders as «class utf8» to fRef
        close access fRef
    on error errMsg number errNum
        close access fRef
        error errMsg number errNum
    end try
    -- Open the file as a document in TextEdit.
    tell application "TextEdit"
        activate
        tell document "Conway's Game of Life.rtf" to if (it exists) then close saving no
        set CGoLDoc to (open RTFFile)
    end tell

    -- Create a universe and display its initial state in the document window.
    set universe to newUniverse(seed, dimensions)
    set {stateText} to universe's currentState()
    tell application "TextEdit" to set CGoLDoc's first attribute run to stateText
    -- Get and display successive states.
    repeat maxGenerations times
        set {stateText, noChanges} to universe's nextState()
        tell application "TextEdit" to set CGoLDoc's first attribute run to stateText
        if (noChanges) then exit repeat
    end repeat
end runGame

set GosperGliderGun to "                        *
                      * *
            **      **            **
           *   *    **            **
**        *     *   **
**        *   * **    * *
          *     *       *
           *   *
            **"
-- Run for 500 generations in a 100 x 100 universe.
runGame(GosperGliderGun, {100, 100}, 500)
