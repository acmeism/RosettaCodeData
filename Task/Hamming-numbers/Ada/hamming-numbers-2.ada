   type My_Index is mod 2**8;
   package My_Big_Numbers is new Big_Number (Index_type => My_Index, Nb_Item => 64);
   function Int2Big is new My_Big_Numbers.Generic_Conversion.Int_Number2Big_Unsigned (Integer);

   function Big_Get_Hamming is new Get_Hamming
      (Int_Type => My_Big_Numbers.Big_Unsigned,
       Zero     => My_Big_Numbers.Big_Unsigned_Zero,
       One      => My_Big_Numbers.Big_Unsigned_One,
       Two      => My_Big_Numbers.Big_Unsigned_Two,
       Three    => Int2Big(3),
       Five     => Int2Big(5),
       "mod"    => My_Big_Numbers.Unsigned_Number."mod",
       "+"      => My_Big_Numbers.Unsigned_Number."+",
       "/"      => My_Big_Numbers.Unsigned_Number."/");
