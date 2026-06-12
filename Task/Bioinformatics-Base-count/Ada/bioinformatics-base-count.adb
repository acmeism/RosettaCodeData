with Ada.Text_Io;

procedure Base_Count is

   type Sequence is new String;
   Test : constant Sequence :=
     "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" &
     "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" &
     "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" &
     "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" &
     "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" &
     "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" &
     "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" &
     "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" &
     "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" &
     "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT";

   Line_Width : constant := 70;

   procedure Put (Seq : Sequence) is
      use Ada.Text_Io;
      package Position_Io is new Ada.Text_Io.Integer_Io (Natural);
      First : Natural := Seq'First;
      Last  : Natural;
   begin
      loop
         Last := Natural'Min (Seq'Last, First + Line_Width - 1);
         Position_Io.Put (First, Width => 3);
         Put (String'(".."));
         Position_Io.Put (Last, Width => 3);
         Put (String'("  "));
         Put (String (Seq (First .. Last)));
         New_Line;
         exit when Last = Seq'Last;
         First := First + Line_Width;
      end loop;
   end Put;

   procedure Count (Seq : Sequence) is
      use Ada.Text_Io;
      A_Count, C_Count : Natural := 0;
      G_Count, T_Count : Natural := 0;
   begin
      for B of Seq loop
         case B is
            when 'A' =>  A_Count := A_Count + 1;
            when 'C' =>  C_Count := C_Count + 1;
            when 'G' =>  G_Count := G_Count + 1;
            when 'T' =>  T_Count := T_Count + 1;
            when others =>
               raise Constraint_Error;
         end case;
      end loop;
      Put_Line ("A: " & A_Count'Image);
      Put_Line ("C: " & C_Count'Image);
      Put_Line ("G: " & G_Count'Image);
      Put_Line ("T: " & T_Count'Image);
      Put_Line ("Total: " & Seq'Length'Image);
   end Count;

begin
   Put (Test);
   Count (Test);
end Base_Count;
