Str0=Hello, This is a sample text with 1 2 3 or other digits!@#$^&*()-_=
Str1 := Rot13(Str0)
Str2 := Rot13(Str1)
MsgBox % Str0 "`n" Str1 "`n" Str2

Rot13(string)
{
   Loop Parse, string
   {
      char := Asc(A_LoopField)
      ; o is 'A' code if it is an uppercase letter, and 'a' code if it is a lowercase letter
      o := Asc("A") * (Asc("A") <= char && char <= Asc("Z")) + Asc("a") * (Asc("a") <= char && char <= Asc("z"))
      If (o > 0)
      {
         ; Set between 0 and 25, add rotation factor, modulus alphabet size
         char := Mod(char - o + 13, 26)
         ; Transform back to char, upper or lower
         char := Chr(char + o)
      }
      Else
      {
         ; Non alphabetic, unchanged
         char := A_LoopField
      }
      rStr .= char
   }
   Return rStr
}
