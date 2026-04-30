with Ada.Strings.Unbounded;

package body Nestable_Lists is

   procedure Append (L : in out List; E : Element_Type) is
   begin
      if L = null then
         L := new Node (Kind => Data_Node);
         L.Data := E;
      else
         Append (L.Next, E);
      end if;
   end Append;

   procedure Append (L : in out List; N : List) is
   begin
      if L = null then
         L := new Node (Kind => List_Node);
         L.Sublist := N;
      else
         Append (L.Next, N);
      end if;
   end Append;

   function Flatten (L : List) return List is
      Result  : List;
      Current : List := L;
      Temp    : List;
   begin
      while Current /= null loop
         case Current.Kind is
            when Data_Node =>
               Append (Result, Current.Data);
            when List_Node =>
               Temp := Flatten (Current.Sublist);
               while Temp /= null loop
                  Append (Result, Temp.Data);
                  Temp := Temp.Next;
               end loop;
         end case;
         Current := Current.Next;
      end loop;
      return Result;
   end Flatten;

   function New_List (E : Element_Type) return List is
   begin
      return  new Node'(Kind => Data_Node, Data => E, Next => null);
   end New_List;

   function New_List (N : List) return List is
   begin
      return new Node'(Kind => List_Node, Sublist => N, Next => null);
   end New_List;

   function To_String (L : List) return String is
      Current : List := L;
      Result  : Ada.Strings.Unbounded.Unbounded_String;
   begin
      Ada.Strings.Unbounded.Append (Result, "[");
      while Current /= null loop
         case Current.Kind is
            when Data_Node =>
               Ada.Strings.Unbounded.Append
                 (Result, To_String (Current.Data));
            when List_Node =>
               Ada.Strings.Unbounded.Append
                 (Result, To_String (Current.Sublist));
         end case;
         if Current.Next /= null then
            Ada.Strings.Unbounded.Append (Result, ", ");
         end if;
         Current := Current.Next;
      end loop;
      Ada.Strings.Unbounded.Append (Result, "]");
      return Ada.Strings.Unbounded.To_String (Result);
   end To_String;

end Nestable_Lists;
