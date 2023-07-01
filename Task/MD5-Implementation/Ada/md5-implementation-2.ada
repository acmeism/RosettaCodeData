with Ada.Unchecked_Conversion;

package body MD5 is
   type Int32_Array is array (Positive range <>) of Int32;

   function Rotate_Left (Value : Int32; Count : Int32) return Int32 is
      Bit    : Boolean;
      Result : Int32 := Value;
   begin
      for I in 1 .. Count loop
         Bit    := (2 ** 31 and Result) = 2 ** 31;
         Result := Result * 2;
         if Bit then
            Result := Result + 1;
         end if;
      end loop;
      return Result;
   end Rotate_Left;

   function Pad_String (Item : String) return Int32_Array is
      -- always pad positive amount of Bytes
      Padding_Bytes : Positive := 64 - Item'Length mod 64;
      subtype String4 is String (1 .. 4);
      function String4_To_Int32 is new Ada.Unchecked_Conversion
        (Source => String4,
         Target => Int32);
   begin
      if Padding_Bytes <= 2 then
         Padding_Bytes := Padding_Bytes + 64;
      end if;
      declare
         Result        : Int32_Array (1 .. (Item'Length + Padding_Bytes) / 4);
         Current_Index : Positive := 1;
      begin
         for I in 1 .. Item'Length / 4 loop
            Result (I)    :=
              String4_To_Int32 (Item (4 * (I - 1) + 1 .. 4 * I));
            Current_Index := Current_Index + 1;
         end loop;

         declare
            Last_String : String4          := (others => Character'Val (0));
            Chars_Left  : constant Natural := Item'Length mod 4;
         begin
            Last_String (1 .. Chars_Left) :=
              Item (Item'Last - Chars_Left + 1 .. Item'Last);
            Last_String (Chars_Left + 1)  := Character'Val (2#1000_0000#);
            Result (Current_Index)        := String4_To_Int32 (Last_String);
            Current_Index                 := Current_Index + 1;
         end;

         Result (Current_Index .. Result'Last) := (others => 0);
         -- append length as bit count
         Result (Result'Last - 1) := Item'Length * 2 ** 3; -- mod 2 ** 32;
         Result (Result'Last)     := Item'Length / 2 ** (32 - 3);
         return Result;
      end;
   end Pad_String;

   function Turn_Around (X : Int32) return Int32 is
      Result : Int32 := 0;
   begin
      for Byte in 1 .. 4 loop
         Result := Result * 16#100#;
         Result := Result + (X / (2 ** (8 * (Byte - 1)))) mod 16#100#;
      end loop;
      return Result;
   end Turn_Around;

   function MD5 (Input : String) return MD5_Hash is
      function F (X, Y, Z : Int32) return Int32 is
      begin
         return Z xor (X and (Y xor Z));
      end F;
      function G (X, Y, Z : Int32) return Int32 is
      begin
         return (X and Z) or (Y and (not Z));
      end G;
      function H (X, Y, Z : Int32) return Int32 is
      begin
         return X xor Y xor Z;
      end H;
      function I (X, Y, Z : Int32) return Int32 is
      begin
         return Y xor (X or (not Z));
      end I;
      T  : constant Int32_Array :=
        (16#d76aa478#, 16#e8c7b756#, 16#242070db#, 16#c1bdceee#,
         16#f57c0faf#, 16#4787c62a#, 16#a8304613#, 16#fd469501#,
         16#698098d8#, 16#8b44f7af#, 16#ffff5bb1#, 16#895cd7be#,
         16#6b901122#, 16#fd987193#, 16#a679438e#, 16#49b40821#,
         16#f61e2562#, 16#c040b340#, 16#265e5a51#, 16#e9b6c7aa#,
         16#d62f105d#, 16#02441453#, 16#d8a1e681#, 16#e7d3fbc8#,
         16#21e1cde6#, 16#c33707d6#, 16#f4d50d87#, 16#455a14ed#,
         16#a9e3e905#, 16#fcefa3f8#, 16#676f02d9#, 16#8d2a4c8a#,
         16#fffa3942#, 16#8771f681#, 16#6d9d6122#, 16#fde5380c#,
         16#a4beea44#, 16#4bdecfa9#, 16#f6bb4b60#, 16#bebfbc70#,
         16#289b7ec6#, 16#eaa127fa#, 16#d4ef3085#, 16#04881d05#,
         16#d9d4d039#, 16#e6db99e5#, 16#1fa27cf8#, 16#c4ac5665#,
         16#f4292244#, 16#432aff97#, 16#ab9423a7#, 16#fc93a039#,
         16#655b59c3#, 16#8f0ccc92#, 16#ffeff47d#, 16#85845dd1#,
         16#6fa87e4f#, 16#fe2ce6e0#, 16#a3014314#, 16#4e0811a1#,
         16#f7537e82#, 16#bd3af235#, 16#2ad7d2bb#, 16#eb86d391#);
      A : Int32 := 16#67452301#;
      B : Int32 := 16#EFCDAB89#;
      C : Int32 := 16#98BADCFE#;
      D : Int32 := 16#10325476#;
      Padded_String : constant Int32_Array := Pad_String (Input);
   begin
      for Block512 in 1 .. Padded_String'Length / 16 loop
         declare
            Words    : constant Int32_Array (1 .. 16) :=
              Padded_String (16 * (Block512 - 1) + 1 .. 16 * Block512);
            AA       : constant Int32                 := A;
            BB       : constant Int32                 := B;
            CC       : constant Int32                 := C;
            DD       : constant Int32                 := D;
         begin
            -- round 1
            A := B + Rotate_Left ((A + F (B, C, D) + Words (1) + T (1)),  7);
            D := A + Rotate_Left ((D + F (A, B, C) + Words (2) + T (2)), 12);
            C := D + Rotate_Left ((C + F (D, A, B) + Words (3) + T (3)), 17);
            B := C + Rotate_Left ((B + F (C, D, A) + Words (4) + T (4)), 22);
            A := B + Rotate_Left ((A + F (B, C, D) + Words (5) + T (5)),  7);
            D := A + Rotate_Left ((D + F (A, B, C) + Words (6) + T (6)), 12);
            C := D + Rotate_Left ((C + F (D, A, B) + Words (7) + T (7)), 17);
            B := C + Rotate_Left ((B + F (C, D, A) + Words (8) + T (8)), 22);
            A := B + Rotate_Left ((A + F (B, C, D) + Words (9) + T (9)),  7);
            D := A + Rotate_Left ((D + F (A, B, C) + Words (10) + T (10)), 12);
            C := D + Rotate_Left ((C + F (D, A, B) + Words (11) + T (11)), 17);
            B := C + Rotate_Left ((B + F (C, D, A) + Words (12) + T (12)), 22);
            A := B + Rotate_Left ((A + F (B, C, D) + Words (13) + T (13)),  7);
            D := A + Rotate_Left ((D + F (A, B, C) + Words (14) + T (14)), 12);
            C := D + Rotate_Left ((C + F (D, A, B) + Words (15) + T (15)), 17);
            B := C + Rotate_Left ((B + F (C, D, A) + Words (16) + T (16)), 22);
            -- round 2
            A := B + Rotate_Left ((A + G (B, C, D) + Words (2) + T (17)),  5);
            D := A + Rotate_Left ((D + G (A, B, C) + Words (7) + T (18)),  9);
            C := D + Rotate_Left ((C + G (D, A, B) + Words (12) + T (19)), 14);
            B := C + Rotate_Left ((B + G (C, D, A) + Words (1) + T (20)), 20);
            A := B + Rotate_Left ((A + G (B, C, D) + Words (6) + T (21)),  5);
            D := A + Rotate_Left ((D + G (A, B, C) + Words (11) + T (22)),  9);
            C := D + Rotate_Left ((C + G (D, A, B) + Words (16) + T (23)), 14);
            B := C + Rotate_Left ((B + G (C, D, A) + Words (5) + T (24)), 20);
            A := B + Rotate_Left ((A + G (B, C, D) + Words (10) + T (25)),  5);
            D := A + Rotate_Left ((D + G (A, B, C) + Words (15) + T (26)),  9);
            C := D + Rotate_Left ((C + G (D, A, B) + Words (4) + T (27)), 14);
            B := C + Rotate_Left ((B + G (C, D, A) + Words (9) + T (28)), 20);
            A := B + Rotate_Left ((A + G (B, C, D) + Words (14) + T (29)),  5);
            D := A + Rotate_Left ((D + G (A, B, C) + Words (3) + T (30)),  9);
            C := D + Rotate_Left ((C + G (D, A, B) + Words (8) + T (31)), 14);
            B := C + Rotate_Left ((B + G (C, D, A) + Words (13) + T (32)), 20);
            -- round 3
            A := B + Rotate_Left ((A + H (B, C, D) + Words (6) + T (33)),  4);
            D := A + Rotate_Left ((D + H (A, B, C) + Words (9) + T (34)), 11);
            C := D + Rotate_Left ((C + H (D, A, B) + Words (12) + T (35)), 16);
            B := C + Rotate_Left ((B + H (C, D, A) + Words (15) + T (36)), 23);
            A := B + Rotate_Left ((A + H (B, C, D) + Words (2) + T (37)),  4);
            D := A + Rotate_Left ((D + H (A, B, C) + Words (5) + T (38)), 11);
            C := D + Rotate_Left ((C + H (D, A, B) + Words (8) + T (39)), 16);
            B := C + Rotate_Left ((B + H (C, D, A) + Words (11) + T (40)), 23);
            A := B + Rotate_Left ((A + H (B, C, D) + Words (14) + T (41)),  4);
            D := A + Rotate_Left ((D + H (A, B, C) + Words (1) + T (42)), 11);
            C := D + Rotate_Left ((C + H (D, A, B) + Words (4) + T (43)), 16);
            B := C + Rotate_Left ((B + H (C, D, A) + Words (7) + T (44)), 23);
            A := B + Rotate_Left ((A + H (B, C, D) + Words (10) + T (45)),  4);
            D := A + Rotate_Left ((D + H (A, B, C) + Words (13) + T (46)), 11);
            C := D + Rotate_Left ((C + H (D, A, B) + Words (16) + T (47)), 16);
            B := C + Rotate_Left ((B + H (C, D, A) + Words (3) + T (48)), 23);
            -- round 4
            A := B + Rotate_Left ((A + I (B, C, D) + Words (1) + T (49)),  6);
            D := A + Rotate_Left ((D + I (A, B, C) + Words (8) + T (50)), 10);
            C := D + Rotate_Left ((C + I (D, A, B) + Words (15) + T (51)), 15);
            B := C + Rotate_Left ((B + I (C, D, A) + Words (6) + T (52)), 21);
            A := B + Rotate_Left ((A + I (B, C, D) + Words (13) + T (53)),  6);
            D := A + Rotate_Left ((D + I (A, B, C) + Words (4) + T (54)), 10);
            C := D + Rotate_Left ((C + I (D, A, B) + Words (11) + T (55)), 15);
            B := C + Rotate_Left ((B + I (C, D, A) + Words (2) + T (56)), 21);
            A := B + Rotate_Left ((A + I (B, C, D) + Words (9) + T (57)),  6);
            D := A + Rotate_Left ((D + I (A, B, C) + Words (16) + T (58)), 10);
            C := D + Rotate_Left ((C + I (D, A, B) + Words (7) + T (59)), 15);
            B := C + Rotate_Left ((B + I (C, D, A) + Words (14) + T (60)), 21);
            A := B + Rotate_Left ((A + I (B, C, D) + Words (5) + T (61)),  6);
            D := A + Rotate_Left ((D + I (A, B, C) + Words (12) + T (62)), 10);
            C := D + Rotate_Left ((C + I (D, A, B) + Words (3) + T (63)), 15);
            B := C + Rotate_Left ((B + I (C, D, A) + Words (10) + T (64)), 21);
            -- increment
            A := A + AA;
            B := B + BB;
            C := C + CC;
            D := D + DD;
         end;
      end loop;
      return
        (Turn_Around (A),
         Turn_Around (B),
         Turn_Around (C),
         Turn_Around (D));
   end MD5;

   function To_String (Item : MD5_Hash) return MD5_String is
      Hex_Chars : constant array (0 .. 15) of Character :=
        ('0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'a', 'b', 'c', 'd', 'e', 'f');
      Result    : MD5_String := (1      => '0',
                                 2      => 'x',
                                 others => '0');
      Temp      : Int32;
      Position  : Natural := Result'Last;
   begin
      for Part in reverse Item'Range loop
         Temp := Item (Part);
         while Position > Result'Last - (5 - Part) * 8 loop
            Result (Position) := Hex_Chars (Natural (Temp mod 16));
            Position          := Position - 1;
            Temp              := Temp / 16;
         end loop;
      end loop;
      return Result;
   end To_String;

end MD5;
