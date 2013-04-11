with Ada.Text_IO, Digraphs, Set_Of_Names, Ada.Command_Line;

procedure Toposort is

   -- shortcuts for package names, intantiation of generic package
   package TIO renames Ada.Text_IO;
   package DG renames Digraphs;
   package SN is new Set_Of_Names(DG.Node_Idx_With_Null);

   -- reat the graph from the file with the given Filename
   procedure Read(Filename: String; G: out DG.Graph_Type; N: out SN.Set) is

      -- finds the first word in S(Start .. S'Last), delimited by spaces
      procedure Find_Token(S: String; Start: Positive;
                           First: out Positive; Last: out Natural) is

      begin
         First := Start;
         while First <= S'Last and then S(First)= ' ' loop
            First := First + 1;
         end loop;
         Last := First-1;
         while Last < S'Last and then S(Last+1) /= ' ' loop
            Last := Last + 1;
         end loop;
      end Find_Token;

      File: TIO.File_Type;
   begin
      TIO.Open(File, TIO.In_File, Filename);
      TIO.Skip_Line(File, 2);
      -- the first two lines contain header and "===...==="
      while not TIO.End_Of_File(File) loop
         declare
            Line: String := TIO.Get_Line(File);
            First: Positive;
            Last: Natural;
            To, From: DG.Node_Index;
         begin
            Find_Token(Line, Line'First, First, Last);
            if Last >= First then
               N.Add(Line(First .. Last), From);
               G.Add_Node(From);
               loop
                  Find_Token(Line, Last+1, First, Last);
                  exit when Last < First;
                     N.Add(Line(First .. Last), To);
                     G.Add_Connection(From, To);
                  end loop;
            end if;
         end;
      end loop;
      TIO.Close(File);
   end Read;

   Graph: DG.Graph_Type;
   Names: SN.Set;

begin
   Read(Ada.Command_Line.Argument(1), Graph, Names);

   -- eliminat self-cycles
   for Start in 1 .. Graph.Node_Count loop
      Graph.Del_Connection(Start, Start);
   end loop;

   -- perform the topological sort and output the result
   declare
      Result:  DG.Node_Vec.Vector;
   begin
      Result := Graph.Top_Sort;
      for Index in Result.First_Index .. Result.Last_Index loop
         TIO.Put(Names.Name(Result.Element(Index)));
         if Index < Result.Last_Index then
            TIO.Put(" -> ");
         end if;
      end loop;
      TIO.New_Line;
   exception
      when DG.Graph_Is_Cyclic =>
         TIO.Put_Line("There is no topological sorting -- the Graph is cyclic!");
   end;
end Toposort;
