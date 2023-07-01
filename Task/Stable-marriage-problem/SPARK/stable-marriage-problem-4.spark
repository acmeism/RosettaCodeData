------------------------------------
--  Test program.
--
--  This is Ada, it is not SPARK.
------------------------------------

with Ada.Text_IO;
with Preferences;
with Propose;
procedure Matchmaker
is
   --  renaming subtypes:
   subtype Guy  is Preferences.Guy;
   subtype Girl is Preferences.Girl;

   Marriages : Propose.Engagements;
   Stable    : Boolean;
   Him       : Preferences.Guy_X;
   Her       : Preferences.Girl_X;
   Stable_Marriages : Propose.Engagements;

   procedure Report_Stable
   is
   begin
      if Stable then
         Ada.Text_IO.Put_Line ("Pairs are Stable");
      else
         Ada.Text_IO.Put ("Pairs are Unstable: ");
         Ada.Text_IO.Put_Line
           (Guy'Image(Him) & " and " & Girl'Image(Her) & " prefer each other.");
      end if;
   end Report_Stable;

begin

   Propose.Engage(Pairs => Marriages);
   for W in Girl loop
      Ada.Text_IO.Put_Line (Girl'Image(W) &
                            " marries " &
                            Guy'Image(Marriages(W)));
   end loop;
   Propose.Check_Stable (Pairs      => Marriages,
                         OK         => Stable,
                         Other_Girl => Her,
                         Other_Guy  => Him);
   Report_Stable;
   Stable_Marriages := Marriages;

   for W1 in Girl range Girl'First .. Girl'Pred(Girl'Last) loop
      for W2 in Girl range Girl'Succ(W1) .. Girl'Last loop
         Ada.Text_IO.New_Line;
         Ada.Text_IO.Put_Line ("Exchange " & Guy'Image(Marriages(W1)) &
                               " with " & Guy'Image(Marriages(W2)));
         Him := Marriages(W1);
         Marriages(W1) := Marriages(W2);
         Marriages(W2) := Him;
         Propose.Check_Stable (Pairs      => Marriages,
                               OK         => Stable,
                               Other_Girl => Her,
                               Other_Guy  => Him);
         Report_Stable;
         Marriages := Stable_Marriages;
      end loop;
   end loop;

end MatchMaker;
