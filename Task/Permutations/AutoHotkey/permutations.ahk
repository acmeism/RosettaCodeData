#NoEnv
StringCaseSense On

o := str := "Hello"

Loop
{
   str := perm_next(str)
   If !str
   {
      MsgBox % clipboard := o
      break
   }
   o.= "`n" . str
}

perm_Next(str){
   p := 0, sLen := StrLen(str)
   Loop % sLen
   {
      If A_Index=1
         continue
      t := SubStr(str, sLen+1-A_Index, 1)
      n := SubStr(str, sLen+2-A_Index, 1)
      If ( t < n )
      {
         p := sLen+1-A_Index, pC := SubStr(str, p, 1)
         break
      }
   }
   If !p
      return false
   Loop
   {
      t := SubStr(str, sLen+1-A_Index, 1)
      If ( t > pC )
      {
         n := sLen+1-A_Index, nC := SubStr(str, n, 1)
         break
      }
   }
   return SubStr(str, 1, p-1) . nC . Reverse(SubStr(str, p+1, n-p-1) . pC .  SubStr(str, n+1))
}

Reverse(s){
   Loop Parse, s
      o := A_LoopField o
   return o
}
