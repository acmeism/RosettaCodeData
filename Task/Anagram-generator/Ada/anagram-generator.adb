pragma Ada_2022;
with Ada.Characters.Handling;   use Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Interfaces;  use Interfaces;

procedure Anagram_Generator is
   MIN_WORD_LEN  : constant Positive := 2;
   MAX_WORD_LEN  : constant Positive := 14;
   DICT_FILENAME : constant String   := "unixdict.txt";
   Invalid_Word  : exception;

   subtype LC_Chars is Character range 'a' .. 'z'; --  used to filter dictionary etc.
   type Dict_Length_Range is range MIN_WORD_LEN .. (MAX_WORD_LEN - MIN_WORD_LEN);
   type Word_Entry_Rec is record
      Word : Unbounded_String;
      Hash : Unsigned_64;
   end record;
   package Word_Vectors is new Ada.Containers.Vectors (Positive, Word_Entry_Rec);
   type Hashed_Dict_Arr is array (Dict_Length_Range) of Word_Vectors.Vector;

   function Hash (Str : String) return Unsigned_64 is
      PRIMES : constant array (LC_Chars) of Unsigned_64 := [2, 3, 5, 7, 11, 13,
         17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101];
      Res : Unsigned_64 := 1;
   begin
      for C of Str loop Res := Res * PRIMES (C); end loop;
      return Res;
   end Hash;

   function Load_Candidate_Words (Dict_Filename : String; Min_Len, Max_Len : Positive)
            return Hashed_Dict_Arr is
      Dict_File  : File_Type;
      Read_Word  : Unbounded_String;
      Cands      : Hashed_Dict_Arr;
      Valid      : Boolean;
      C          : Character;
      Word_Len   : Positive;
      Word_Entry : Word_Entry_Rec;
   begin
      Open (File => Dict_File, Mode => In_File, Name => Dict_Filename);
      while not End_Of_File (Dict_File) loop
         Read_Word := Get_Line (Dict_File);
         Word_Len := Length (Read_Word);
         if Word_Len in Min_Len .. Max_Len then
            Valid := True;
            for Ix in 1 .. Word_Len loop
               C := Element (Read_Word, Ix);
               Valid := C in LC_Chars;
               exit when not Valid;
            end loop;
            if Valid then
               Word_Entry.Word := Read_Word;
               Word_Entry.Hash := Hash (To_String (Read_Word));
               Cands (Dict_Length_Range (Word_Len)).Append (Word_Entry);
            end if;
         end if;
      end loop;
      Close (Dict_File);
      return Cands;
   end Load_Candidate_Words;

   procedure Find_Words (Len_1, Len_2 : Integer; Hash_1, Hash_2 : Unsigned_64;
                         Dict : in out Hashed_Dict_Arr) is
   begin
      for WE_1 of Dict (Dict_Length_Range (Len_1)) loop
         if WE_1.Hash = Hash_1 then
            for WE_2 of Dict (Dict_Length_Range (Len_2)) loop
               if WE_2.Hash = Hash_2 then
                  Put_Line ("   " & WE_1.Word & " " & WE_2.Word);
               end if;
            end loop;
            WE_1.Hash := 0; --  Don't reuse this word
         end if;
      end loop;
   end Find_Words;

   function Pop_Count (N : Unsigned_32) return Natural is
      V : Unsigned_32 := N;
   begin
      V := V - (Shift_Right (V, 1) and 16#55555555#);
      V := (V and 16#33333333#) + (Shift_Right (V, 2) and 16#33333333#);
      V := Shift_Right (((V + Shift_Right (V, 4) and 16#f0f0f0f#) * 16#1010101#), 24);
      return Natural (V);
   end Pop_Count;

   function Next (N : Unsigned_32) return Unsigned_32 is
      Res  : Unsigned_32;
      Ones : constant Natural := Pop_Count (N);
   begin
      case Ones is
         when 0 => return 0;
         when 1 => return Shift_Left (N, 1);
         when others =>  --  Simple implementation
            Res := N + 1;
            while Pop_Count (Res) /= Ones loop
               Res := Res + 1;
            end loop;
            return Res;
      end case;
   end Next;

   function Masked_Chars (Src : String; Mask : Unsigned_32) return String is
      Res : String (1 .. Pop_Count (Mask));
      Shifted : Unsigned_32 := Mask;
      Str_Ix  : Positive := 1;
   begin
      for I in 1 .. Src'Length loop
         if (Shifted and 1) = 1 then
            Res (Str_Ix) := Src (I);
            Str_Ix := @ + 1;
         end if;
         Shifted := Shift_Right (Shifted, 1);
         exit when Shifted = 0;  --  short-circuit an empty mask
      end loop;
      return Res;
   end Masked_Chars;

   procedure Anagram (Word : String) is
      Word_LC        : constant String := To_Lower (Word);
      Max_Search_Len : constant Positive := Word'Length - MIN_WORD_LEN;
      Hashed_Dict    : Hashed_Dict_Arr;
      Part_1_Len, Part_2_Len : Integer;
      Part_1         : Unsigned_32;
      Part_Len_Mask  : constant Unsigned_32 := (2 ** Word'Length) - 1;
   begin
      if Word'Length not in MIN_WORD_LEN .. MAX_WORD_LEN then
         raise Invalid_Word with "Word length out of allowed range.";
      end if;
      Hashed_Dict := Load_Candidate_Words (DICT_FILENAME, MIN_WORD_LEN, Max_Search_Len);
      Put_Line ("Two-word anagrams of " & Word & "...");
      Part_1_Len := Word'Length - MIN_WORD_LEN;
      Part_2_Len := Word'Length - Part_1_Len;
      while Part_1_Len >= Part_2_Len loop
         Part_1 := Unsigned_32 (2 ** (Part_1_Len) - 1);
         while Part_1 < 2 ** Word'Length loop
            Find_Words (Part_1_Len, Part_2_Len, Hash (Masked_Chars(Word_LC, Part_1)),
                        Hash (Masked_Chars(Word_LC, (not Part_1) and Part_Len_Mask)), Hashed_Dict);
            Part_1 := Next (Part_1);
         end loop;
         Part_1_Len := @ - 1;
         Part_2_Len := @ + 1;
      end loop;
   end Anagram;
begin
   Anagram ("Purefox");
   Anagram ("Petelomax");
   Anagram ("rosettacode");
end Anagram_Generator;
