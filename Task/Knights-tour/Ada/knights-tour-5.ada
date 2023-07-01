   function Warnsdorff_Get_Tour(Start_X, Start_Y: Index;  Scene: Tour := Empty)
			       return Tour is
      Done: Boolean;
      Visited: Tour; -- see comments from Get_Tour above
      Move_Count: Natural := Count_Moves(Scene);

      function Neighbors(X, Y: Index) return Natural is
         Result: Natural := 0;
      begin
         for P in Pairs'Range loop
            if X+Pairs(P)(1) in Index and then Y+Pairs(P)(2) in Index and then
              Visited(X+Pairs(P)(1),  Y+Pairs(P)(2)) = 0 then
               Result := Result + 1;
            end if;
         end loop;
         return Result;
      end Neighbors;

      procedure Sort(Options: in out Pair_Array) is
         N_Bors: array(Options'Range) of Natural;
         K: Positive range Options'Range;
         N: Natural;
         P: Pair;
      begin
         for Opt in Options'Range loop
            N_Bors(Opt) := Neighbors(Options(Opt)(1), Options(Opt)(2));
         end loop;
         for Opt in Options'Range loop
            K := Opt;
            for Alternative in Opt+1 .. Options'Last loop
               if N_Bors(Alternative) < N_Bors(Opt) then
                  K := Alternative;
               end if;
            end loop;
            N           := N_Bors(Opt);
            N_Bors(Opt) := N_Bors(K);
            N_Bors(K)   := N;
            P            := Options(Opt);
            Options(Opt) := Options(K);
            Options(K)   := P;
         end loop;
      end Sort;

      procedure Visit(X, Y: Index; Move: Positive; Found: out Boolean) is
         Next_Count: Natural range 0 .. 8 := 0;
         Next_Steps: Pair_Array(1 .. 8);
         XX, YY: Integer;
      begin
         Found := False;
         Visited(X, Y) := Move;
         if Move = Move_Count then
            Found := True;
         else
            -- consider all possible places to go
            for P in Pairs'Range loop
               XX := X + Pairs(P)(1);
               YY := Y + Pairs(P)(2);
               if (XX in Index) and then (YY in Index)
                 and then Visited(XX, YY) = 0 then
                  Next_Count := Next_Count+1;
                  Next_Steps(Next_Count) := (XX, YY);
               end if;
            end loop;

            Sort(Next_Steps(1 .. Next_Count));

            for N in 1 .. Next_Count loop
               Visit(Next_Steps(N)(1), Next_Steps(N)(2), Move+1, Found);
               if Found then
                  return; -- no need to search further
            end if;
            end loop;

            -- if we didn't return above, we have to undo our move
            Visited(X, Y) := 0;
         end if;
      end Visit;

   begin
      Visited := Scene;
      Visit(Start_X, Start_Y, 1, Done);
      if not Done then
         Visited := Scene;
      end if;
      return Visited;
   end Warnsdorff_Get_Tour;
