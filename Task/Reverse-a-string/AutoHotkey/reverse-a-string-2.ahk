Reverse(String){ ; credit to Rseding91
   If (A_IsUnicode){
      SLen := StrLen(String) * 2
      VarSetCapacity(RString,SLen)

      Loop,Parse,String
         NumPut(Asc(A_LoopField),RString,SLen-(A_Index * 2),"UShort")
   } Else {
      SLen := StrLen(String)
      VarSetCapacity(RString,SLen)

      Loop,Parse,String
         NumPut(Asc(A_LoopField),RString,SLen-A_Index,"UChar")
   }

   VarSetCapacity(RString,-1)

   Return RString
}
