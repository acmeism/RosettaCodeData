with Ada.Text_IO; use Ada.Text_IO;
with Dijkstra;
procedure Test_Dijkstra is
   subtype t_Tested_Vertices is Character range 'a'..'f';
   package Tested is new Dijkstra (t_Vertex => t_Tested_Vertices);
   use Tested;
   Graph : t_Graph := Build (Edges => (('a', 'b', 7),
                                       ('a', 'c', 9),
                                       ('a', 'f', 14),
                                       ('b', 'c', 10),
                                       ('b', 'd', 15),
                                       ('c', 'd', 11),
                                       ('c', 'f', 2),
                                       ('d', 'e', 6),
                                       ('e', 'f', 9)));
   procedure Display_Path (From, To : in t_Tested_Vertices) is
      function Path_Image (Path : in t_Path; Start : Boolean := True) return String is
        ((if Start then "["
          elsif Path'Length /= 0 then ","
          else "") &
         (if Path'Length = 0 then "]"
          else Path(Path'First) & Path_Image(Path(Path'First+1..Path'Last), Start => False)));
   begin
      Put      ("Path from '" & From & "' to '" & To & "' = ");
      Put_Line (Path_Image (Shortest_Path (Graph, From, To))
                & " distance =" & Distance (Graph, From, To)'Img);
   exception
      when others => Put_Line("no path");
   end Display_Path;
begin
   Display_Path ('a', 'e');
   Display_Path ('a', 'f');
   New_Line;
   for From in t_Tested_Vertices loop
      for To in t_Tested_Vertices loop
         Display_Path (From, To);
      end loop;
   end loop;
end Test_Dijkstra;
