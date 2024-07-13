-- Permutation sort
-- J. Carter     2024 Jun
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Permutations;

procedure Slow_Sort is
   package Char_Perms is new PragmARC.Permutations (Element => Character);

   procedure Put (Item : in Char_Perms.Sequence);
   -- Outputs all the Characters in Item to standard output, followed by a line terminator

   procedure Process (Seq : in Char_Perms.Sequence; Stop : in out Boolean);
   -- If Seq is sorted, outputs it and sets Stop to True

   procedure Put (Item : in Char_Perms.Sequence) is
      -- Empty
   begin -- Put
      All_Chars : for C of Item loop
         Ada.Text_IO.Put (Item => C);
      end loop All_Chars;

      Ada.Text_IO.New_Line;
   end Put;

   procedure Process (Seq : in Char_Perms.Sequence; Stop : in out Boolean) is
      -- Empty
   begin -- Process
      if (for all J in 1 .. Seq'Last - 1 => Seq (J) <= Seq (J + 1) ) then -- Sorted
         Put (Item => Seq);
         Stop := True;
      end if;
   end Process;

   Test : constant Char_Perms.Sequence := "kjihgfedcba";
begin -- Slow_Sort
   Char_Perms.Generate (Initial => Test, Process => Process'Access);
end Slow_Sort;
