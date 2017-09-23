' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '
' ABC_Problem                                       '
'                                                   '
' Developed by A. David Garza Marín in VB-DOS for   '
' RosettaCode. November 29, 2016.                   '
' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' '

' Comment the following line to run it in QB or QBasic
OPTION EXPLICIT  ' Modify to OPTION _EXPLICIT for QB64

' SUBs and FUNCTIONs
DECLARE SUB doCleanBlocks ()
DECLARE FUNCTION ICanMakeTheWord (WhichWord AS STRING) AS INTEGER
DECLARE SUB doReadBlocks ()

' rBlock Data Type
TYPE regBlock
  Block AS STRING * 2
  Used AS INTEGER
END TYPE

' Initialize
CONST False = 0, True = NOT False, HMBlocks = 20
DATA "BO", "XK", "DQ", "CP", "NA", "GT","RE", "TG"
DATA "QD", "FS", "JW", "HU", "VI", "AN", "OB", "ER"
DATA "FS", "LY", "PC","ZM"

DIM rBlock(1 TO HMBlocks) AS regBlock
DIM i AS INTEGER, aWord AS STRING, YorN AS STRING

doReadBlocks ' Read the data in the blocks

'-------------- Main program cycle ------------------
CLS
PRINT "This program has the following blocks: ";
FOR i = 1 TO HMBlocks
  PRINT rBlock(i).Block; "|";
NEXT i
PRINT : PRINT
PRINT "Please, write a word or a short sentence to see if the available"
PRINT "blocks can make it. If so, I will tell you."
DO
  doCleanBlocks ' Clean all blocks
  PRINT
  INPUT "Which is the word"; aWord
  aWord = LTRIM$(RTRIM$(aWord))

  IF aWord <> "" THEN
    IF ICanMakeTheWord(aWord) THEN
      PRINT "Yes, i can make it."
    ELSE
      PRINT "No, I can't make it."
    END IF
  ELSE
    PRINT "At least, you need to type a letter."
  END IF

  PRINT
  PRINT "Do you want to try again (Y/N) ";
  DO
    YorN = INPUT$(1)
    YorN = UCASE$(YorN)
  LOOP UNTIL YorN = "Y" OR YorN = "N"
  PRINT YorN

LOOP UNTIL YorN = "N"
' -------------- End of Main program ----------------
END

SUB doCleanBlocks ()
  ' Var
  SHARED rBlock() AS regBlock
  DIM i AS INTEGER

  ' Will clean the Used status of all blocks
  FOR i = 1 TO HMBlocks
    rBlock(i).Used = False
  NEXT i

END SUB

SUB doReadBlocks ()
  ' Var
  SHARED rBlock() AS regBlock
  DIM i AS INTEGER

  ' Will read the block values from DATA
  FOR i = 1 TO HMBlocks
    READ rBlock(i).Block
  NEXT i
END SUB

FUNCTION ICanMakeTheWord (WhichWord AS STRING) AS INTEGER ' Comment AS INTEGER to run in QBasic, QB64 and QuickBASIC
  ' Var
  SHARED rBlock() AS regBlock
  DIM i AS INTEGER, l AS INTEGER, j AS INTEGER, iYesICan AS INTEGER
  DIM c AS STRING, sUWord AS STRING

  ' Will evaluate if can make the word
  sUWord = UCASE$(WhichWord)
  l = LEN(sUWord)
  i = 0

  DO
    i = i + 1
    iYesICan = False
    c = MID$(sUWord, i, 1)
    j = 0
    DO
      j = j + 1
      IF NOT rBlock(j).Used THEN
        iYesICan = (INSTR(rBlock(j).Block, c) > 0)
        rBlock(j).Used = iYesICan
      END IF
    LOOP UNTIL j >= HMBlocks OR iYesICan

  LOOP UNTIL i >= l OR NOT iYesICan

  ' The result will depend on the last value of
  '  iYesICan variable. If the last value is True
  '  is because the function found even the last
  '  letter analyzed.
  ICanMakeTheWord = iYesICan

END FUNCTION
