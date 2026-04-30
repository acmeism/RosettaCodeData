   type Priority is range 1..4;
   type Infix is record
      Precedence : Priority;
      Expression : Unbounded_String;
   end record;
   package Expression_Stack is new Generic_Stack (Infix);
   use Expression_Stack;

   function Convert (RPN : String) return String is
      Arguments : Stack;
      procedure Pop
                (  Operation   : Character;
                   Precedence  : Priority;
                   Association : Priority
                )  is
         Right, Left : Infix;
         Result      : Infix;
      begin
         Pop (Right, Arguments);
         Pop (Left,  Arguments);
         Result.Precedence := Association;
         if Left.Precedence < Precedence then
            Append (Result.Expression, '(');
            Append (Result.Expression, Left.Expression);
            Append (Result.Expression, ')');
         else
            Append (Result.Expression, Left.Expression);
         end if;
         Append (Result.Expression, ' ');
         Append (Result.Expression, Operation);
         Append (Result.Expression, ' ');
         if Right.Precedence < Precedence then
            Append (Result.Expression, '(');
            Append (Result.Expression, Right.Expression);
            Append (Result.Expression, ')');
         else
            Append (Result.Expression, Right.Expression);
         end if;
         Push (Result, Arguments);
      end Pop;
      Pointer : Integer := RPN'First;
   begin
      while Pointer <= RPN'Last loop
         case RPN (Pointer) is
            when ' ' =>
               Pointer := Pointer + 1;
            when '0'..'9' =>
               declare
                  Start : constant Integer := Pointer;
               begin
                  loop
                     Pointer := Pointer + 1;
                     exit when Pointer > RPN'Last
                       or else RPN (Pointer) not in '0'..'9';
                  end loop;
                  Push
                  (  (  4,
                        To_Unbounded_String (RPN (Start..Pointer - 1))
                     ),
                     Arguments
                  );
               end;
            when '+' | '-' =>
               Pop (RPN (Pointer), 1, 1);
               Pointer := Pointer + 1;
            when '*' | '/' =>
               Pop (RPN (Pointer), 2, 2);
               Pointer := Pointer + 1;
            when '^' =>
               Pop (RPN (Pointer), 4, 3);
               Pointer := Pointer + 1;
            when others =>
               raise Constraint_Error with "Syntax";
         end case;
      end loop;
      declare
         Result : Infix;
      begin
         Pop (Result, Arguments);
         return To_String (Result.Expression);
      end;
   end Convert;
