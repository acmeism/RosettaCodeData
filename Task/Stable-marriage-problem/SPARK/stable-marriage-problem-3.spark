with Preferences;
use type Preferences.Extended_Rank;
use type Preferences.Girl;
use type Preferences.Guy;
package body Propose
is

   --  renaming subtypes:
   subtype Guy  is Preferences.Guy;
   subtype Girl is Preferences.Girl;

   function Her_Rank_Of_Him (Her : Girl;
                             Him : Guy) return Preferences.Rank
   is
      R : Preferences.Rank;
   begin
      R := Preferences.Rank'First;
      while Preferences.Girls_Like(Her)(R) /= Him
        and R /= Preferences.Rank'Last
      loop
         R := Preferences.Rank'Succ(R);
      end loop;
      return R;
   end Her_Rank_Of_Him;

   function His_Rank_Of_Her (Him : Guy;
                             Her : Girl) return Preferences.Rank
   is
      R : Preferences.Rank;
   begin
      R := Preferences.Rank'First;
      while Preferences.Guys_Like(Him)(R) /= Her
        and R /= Preferences.Rank'Last
      loop
         R := Preferences.Rank'Succ(R);
      end loop;
      return R;
   end His_Rank_Of_Her;

   procedure Engage (Pairs :    out Engagements)
   is
      type Free_Guy  is array (Guy)  of Boolean;
      type Free_Girl is array (Girl) of Boolean;
      type Last_Proposals is array (Guy) of Preferences.Extended_Rank;

      --  Initialize all M in M_Free and W in W_Free to free.
      M_Free : Free_Guy  := Free_Guy'(others => True);
      W_Free : Free_Girl := Free_Girl'(others => True);
      Last_Proposal : Last_Proposals :=
        Last_Proposals'(others => Preferences.Extended_Rank'First);

      All_Paired : Boolean := False;
      W  : Girl;
      M1 : Preferences.Guy_X;

   begin
      --  Initially set all engagements to null.
      Pairs := Engagements'(others => Preferences.No_Guy);
      --  while there is a free man M who still has a woman W to propose to
      while not All_Paired loop
         All_Paired := True;
         for M in Guy loop
            if M_Free(M) and Last_Proposal(M) < Preferences.Rank'Last then
               All_Paired := False;
               --  W = M's highest ranked such woman who he has not
               --            proposed to yet
               Last_Proposal(M) := Preferences.Rank'Succ(Last_Proposal(M));
               W := Preferences.Guys_Like(M)(Last_Proposal(M));
               --  if W is free
               if W_Free(W) then
                  --  (M, W) become engaged
                  M_Free(M) := False;
                  W_Free(W) := False;
                  Pairs(W)  := M;
               else
                  --  else some pair (M1, W) already exists
                  M1 := Pairs(W);
                  if M1 > Preferences.no_guy and then
                  --  if W prefers M to M1
                    Her_Rank_Of_Him (Her => W, Him => M)
                    < Her_Rank_Of_Him (Her => W, Him => M1)
                  then
                     --  (M, W) become engaged
                     M_Free(M) := False;
                     Pairs(W)  := M;
                     --  M1 becomes free
                     M_Free(M1) := True;
                  else
                     --  (M1, W) remain engaged
                     null;
                  end if;
               end if;
            end if;
         end loop;
      end loop;
   end Engage;

   procedure Check_Stable (Pairs      : in     Engagements;
                           OK         :    out Boolean;
                           Other_Girl :    out Preferences.Girl_X;
                           Other_Guy  :    out Preferences.Guy_X)
   is
      M      : Preferences.Guy_X;
      W_Rank : Preferences.Rank;
   begin
      OK := True;
      Other_Girl := Preferences.No_Girl;
      Other_Guy  := Preferences.No_Guy;
      --  Loop over all girls.
      for W in Girl loop
         if Pairs(W) > Preferences.no_guy then
            W_Rank := Her_Rank_Of_Him (W, Pairs(W));
            --  Loop over all guys she prefers to her current guy.
            for WR in Preferences.Rank range 1 .. W_Rank - 1 loop
               M := Preferences.Girls_Like(W)(WR);
               if M > Preferences.no_guy then
                  --  Loop over all girls for this guy in preference order.
                  for MR in Preferences.Rank
                  --# assert M > Preferences.no_guy;
                  loop
                     --  Exit if his current girl found before this girl.
                     exit when M = Pairs(Preferences.Guys_Like(M)(MR));
                     --  Unstable if this girl found before his current girl.
                     if Preferences.Guys_Like(M)(MR) = W then
                        OK := False;
                        Other_Girl := W;
                        Other_Guy  := M;
                     end if;
                  end loop;
               end if;
               exit when not OK;
            end loop;
         end if;
         exit when not OK;
      end loop;
   end Check_Stable;

end Propose;
