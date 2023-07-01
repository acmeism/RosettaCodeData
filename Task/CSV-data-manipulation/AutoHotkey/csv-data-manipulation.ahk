Loop, Read, Data.csv
{
    i := A_Index
    Loop, Parse, A_LoopReadLine, CSV
        Output .= (i=A_Index && i!=1 ? A_LoopField**2 : A_LoopField) (A_Index=5 ? "`n" : ",")
}
FileAppend, %Output%, NewData.csv
