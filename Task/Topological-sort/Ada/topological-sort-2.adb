package body Digraphs is

   function Node_Count(Graph: Graph_Type) return Node_Idx_With_Null is
   begin
      return Node_Idx_With_Null(Graph.Length);
   end Node_Count;

   procedure Add_Node(Graph: in out Graph_Type'Class; Node: Node_Index) is
   begin
      for I in Node_Index range Graph.Node_Count+1 .. Node loop
         Graph.Append(Node_Vec.Empty_Vector);
      end loop;
   end Add_Node;

   procedure Add_Connection
     (Graph: in out Graph_Type'Class; From, To: Node_Index) is
   begin
      Graph.Add_Node(Node_Index'Max(From, To));
      declare
         Connection_List: Node_Vec.Vector := Graph.Element(From);
      begin
         for I in Connection_List.First_Index .. Connection_List.Last_Index loop
            if Connection_List.Element(I) >= To then
               if Connection_List.Element(I) = To then
                  return; -- if To is already there, don't add it a second time
               else -- I is the first index with Element(I)>To, insert To here
                  Connection_List.Insert(Before => I, New_Item => To);
                  Graph.Replace_Element(From, Connection_List);
                  return;
               end if;
            end if;
         end loop;
         -- there was  no I with no Element(I) > To, so insert To at the end
         Connection_List.Append(To);
         Graph.Replace_Element(From, Connection_List);
         return;
      end;
   end Add_Connection;

   procedure Del_Connection
     (Graph: in out Graph_Type'Class; From, To: Node_Index) is
      Connection_List: Node_Vec.Vector := Graph.Element(From);
   begin
      for I in Connection_List.First_Index .. Connection_List.Last_Index loop
         if Connection_List.Element(I) = To then
            Connection_List.Delete(I);
            Graph.Replace_Element(From, Connection_List);
            return; -- we are done
         end if;
      end loop;
   end Del_Connection;

   function Connected
     (Graph: Graph_Type; From, To: Node_Index) return Boolean is
      Connection_List: Node_Vec.Vector renames Graph.Element(From);
   begin
      for I in Connection_List.First_Index .. Connection_List.Last_Index loop
         if Connection_List.Element(I) = To then
            return True;
         end if;
      end loop;
      return False;
   end Connected;

   function All_Connections
     (Graph: Graph_Type; From: Node_Index) return Node_Vec.Vector is
   begin
      return Graph.Element(From);
   end All_Connections;

   function Top_Sort
     (Graph: Graph_Type) return Node_Vec.Vector is

      Result: Node_Vec.Vector;
      Visited: array(1 .. Graph.Node_Count) of Boolean := (others => False);
      Active:  array(1 .. Graph.Node_Count) of Boolean := (others => False);

      procedure Visit(Node: Node_Index) is
      begin
         if not Visited(Node) then
            Visited(Node) := True;
            Active(Node)  := True;
            declare
               Cons: Node_Vec.Vector := All_Connections(Graph, Node);
            begin
               for Idx in Cons.First_Index .. Cons.Last_Index loop
                  Visit(Cons.Element(Idx));
               end loop;
            end;
            Active(Node) := False;
            Result.Append(Node);
         else
            if Active(Node) then
               raise Constraint_Error with "Graph is Cyclic";
            end if;
         end if;
      end Visit;

   begin
      for Some_Node in Visited'Range loop
         Visit(Some_Node);
      end loop;
      return Result;
   end Top_Sort;

end Digraphs;
