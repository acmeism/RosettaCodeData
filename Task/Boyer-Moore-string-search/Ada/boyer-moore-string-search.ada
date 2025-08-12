with Ada.Text_IO;

with GNATColl.Boyer_Moore;

procedure Boyermoore is

   procedure Search_All (Needle   : in String;
                         Haystack : in String)
   is
      use Ada.Text_IO;
      use GNATColl.Boyer_Moore;

      Found    : String (Haystack'Range) := (others => ' ');
      Count    : Natural  := 0;
      Motif    : Pattern;
      First    : Positive := Haystack'First;
      Position : Integer;
   begin
      Put_Line ("Needle  : " & Needle);
      Put_Line ("Haystack: " & Haystack);
      Put      ("Found   : ");

      Compile (Motif          => Motif,
               From_String    => Needle,
               Case_Sensitive => True);
      loop
         Position := Search (Motif     => Motif,
                             In_String => Haystack (First .. Haystack'Last));
         exit when Position = -1;

         Count := Count + 1;
         Found (Position .. Position + Needle'Length - 1) := (others => '^');
         First := Position + 1;
      end loop;

      Free (Motif);

      if Count = 0 then
         Put_Line ("<not found>");
      else
         Put_Line (Found);
      end if;
      New_Line;
   end Search_All;

   Text_1 : constant String := "InhisbookseriesTheArtofComputerProgrammingpublishedbyAddisonWesleyDKnuthusesanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguagestoillustratetheconceptsandalgorithmsastheyarepresented";

   Text_2 : constant String := "Nearby farms grew a half acre of alfalfa on the dairy's behalf, with bales of all that alfalfa exchanged for milk.";

   Text_3 : constant String := "GCTAGCTCTACGAGTCTA";
   Text_4 : constant String := "GGCTATAATGCGTA";
   Text_5 : constant String := "there would have been a time for such a word";
   Text_6 : constant String := "needle need noodle needle";

begin
   Search_All ("put",     Text_1);
   Search_All ("and",     Text_1);
   Search_All ("alfalfa", Text_2);
   Search_All ("TCTA",    Text_3);
   Search_All ("TAATAAA", Text_4);
   Search_All ("word",    Text_5);
   Search_All ("needle",  Text_6);
end Boyermoore;
