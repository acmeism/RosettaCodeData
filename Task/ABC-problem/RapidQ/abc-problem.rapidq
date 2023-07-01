dim Blocks as string
dim InWord as string

Function CanMakeWord (FInWord as string, FBlocks as string) as integer
    dim WIndex as integer, BIndex as integer

    FBlocks = UCase$(FBlocks) - " " - ","
    FInWord = UCase$(FInWord)

    for WIndex = 1 to len(FInWord)
        BIndex = instr(FBlocks, FInWord[WIndex])

        if BIndex then
            FBlocks = Replace$(FBlocks,"**",iif(BIndex mod 2,BIndex,BIndex-1))
        else
            Result = 0
            exit function
        end if
    next

    Result = 1
end function

InWord = "Confuse"
Blocks = "BO, XK, DQ, CP, NA, GT, RE, TG, QD, FS, JW, HU, VI, AN, OB, ER, FS, LY, PC, ZM"
showmessage "Can make: " + InWord + " = " + iif(CanMakeWord(InWord, Blocks), "True", "False")
