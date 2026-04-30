package body Set_Cons is

   function "+"(E: Element) return Set is
      S: Set := (others => False);
   begin
      S(E) := True;
      return S;
   end "+";

   function "+"(Left, Right: Element) return Set is
   begin
      return (+Left) + Right;
   end "+";

   function "+"(Left: Set; Right: Element) return Set is
      S: Set := Left;
   begin
      S(Right) := True;
      return S;
   end "+";

   function "-"(Left: Set; Right: Element) return Set is
      S: Set := Left;
   begin
      S(Right) := False;
      return S;
   end "-";

   function Nonempty_Intersection(Left, Right: Set) return Boolean is
   begin
      for E in Element'Range loop
         if Left(E) and then Right(E) then return True;
         end if;
      end loop;
      return False;
   end Nonempty_Intersection;

   function Union(Left, Right: Set) return Set is
      S: Set := Left;
   begin
      for E in Right'Range loop
         if Right(E) then S(E) := True;
         end if;
      end loop;
      return S;
   end Union;

   function Image(S: Set) return String is

      function Image(S: Set; Found: Natural) return String is
      begin
         for E in S'Range loop
            if S(E) then
               if Found = 0 then
                  return Image(E) & Image((S-E), Found+1);
               else
                  return "," & Image(E) & Image((S-E), Found+1);
               end if;
            end if;
         end loop;
         return "";
      end Image;

   begin
      return "{" & Image(S, 0) & "}";
   end Image;

   function Image(V: Set_Vec) return String is
    begin
      if V'Length = 0 then
         return "";
      else
         return Image(V(V'First)) & Image(V(V'First+1 .. V'Last));
      end if;
   end Image;

end Set_Cons;
