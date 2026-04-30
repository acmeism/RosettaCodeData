with Ada.Text_IO; use Ada.Text_IO;

procedure Game24_Solver is
   subtype Index is Positive range 1 .. 4;
   subtype Digit is Integer range 1 .. 9;
   type Digit_Array_Type is array (Index) of Digit;

   Success_Exception : exception;

   Digit_Array : Digit_Array_Type;

   procedure Swap (A, B : Index) is
      Tmp : Digit;
   begin
      if A /= B then
         Tmp := Digit_Array (A);
         Digit_Array (A) := Digit_Array (B);
         Digit_Array (B) := Tmp;
      end if;
   end Swap;

   procedure Do_Operation_Options is
      type Operation_Character is ('+', '-', '*', '/');
      type Operation_Access is
        access function (Left, Right : Float) return Float;
      type Allowed_Operation_Array_Type is
        array (Operation_Character) of Operation_Access;

      function Operation_Character_To_String
        (C : in Operation_Character) return String is
      begin
         case C is
            when '+' =>
               return "+";

            when '-' =>
               return "-";

            when '*' =>
               return "*";

            when '/' =>
               return "/";
         end case;
      end Operation_Character_To_String;

      function Add_Floats (Left, Right : Float) return Float is
      begin
         return Left + Right;
      end Add_Floats;

      function Subtract_Floats (Left, Right : Float) return Float is
      begin
         return Left - Right;
      end Subtract_Floats;

      function Multiply_Floats (Left, Right : Float) return Float is
      begin
         return Left * Right;
      end Multiply_Floats;

      function Divide_Floats (Left, Right : Float) return Float is
      begin
         return Left / Right;
      end Divide_Floats;

      Allowed_Operation_Array : constant Allowed_Operation_Array_Type :=
        ('+' => Add_Floats'Access,
         '-' => Subtract_Floats'Access,
         '*' => Multiply_Floats'Access,
         '/' => Divide_Floats'Access);

      A : Digit renames Digit_Array (1);
      B : Digit renames Digit_Array (2);
      C : Digit renames Digit_Array (3);
      D : Digit renames Digit_Array (4);
   begin
      for Op1 in Operation_Character loop
         for Op2 in Operation_Character loop
            for Op3 in Operation_Character loop
               if (Allowed_Operation_Array (Op3)
                     (Allowed_Operation_Array (Op2)
                        (Allowed_Operation_Array (Op1) (Float (A), Float (B)),
                         Float (C)),
                      Float (D)))
                 = 24.0
               then
                  Put_Line
                    ("(("
                     & Digit'Image (A)
                     & " "
                     & Operation_Character_To_String (Op1)
                     & " "
                     & Digit'Image (B)
                     & ") "
                     & Operation_Character_To_String (Op2)
                     & " "
                     & Digit'Image (C)
                     & ") "
                     & Operation_Character_To_String (Op3)
                     & " "
                     & Digit'Image (D));
                  raise Success_Exception;
               end if;
               if (Allowed_Operation_Array (Op2)
                     (Allowed_Operation_Array (Op1) (Float (A), Float (B)),
                      Allowed_Operation_Array (Op3) (Float (C), Float (D))))
                 = 24.0
               then
                  Put_Line
                    ("("
                     & Digit'Image (A)
                     & " "
                     & Operation_Character_To_String (Op1)
                     & " "
                     & Digit'Image (B)
                     & ") "
                     & Operation_Character_To_String (Op2)
                     & " ("
                     & Digit'Image (C)
                     & " "
                     & Operation_Character_To_String (Op3)
                     & " "
                     & Digit'Image (D)
                     & ")");
                  raise Success_Exception;
               end if;
               if (Allowed_Operation_Array (Op1)
                     (Float (A),
                      Allowed_Operation_Array (Op2)
                        (Float (B),
                         Allowed_Operation_Array (Op3)
                           (Float (C), Float (D)))))
                 = 24.0
               then
                  Put_Line
                    (Digit'Image (A)
                     & " "
                     & Operation_Character_To_String (Op1)
                     & " ("
                     & Digit'Image (B)
                     & " "
                     & Operation_Character_To_String (Op2)
                     & " ("
                     & Digit'Image (C)
                     & " "
                     & Operation_Character_To_String (Op3)
                     & " "
                     & Digit'Image (D)
                     & "))");
                  raise Success_Exception;
               end if;
               if (Allowed_Operation_Array (Op1)
                     (Float (A),
                      Allowed_Operation_Array (Op3)
                        (Allowed_Operation_Array (Op2) (Float (B), Float (C)),
                         Float (D))))
                 = 24.0
               then
                  Put_Line
                    (Digit'Image (A)
                     & " "
                     & Operation_Character_To_String (Op1)
                     & " (("
                     & Digit'Image (B)
                     & " "
                     & Operation_Character_To_String (Op2)
                     & " "
                     & Digit'Image (C)
                     & ") "
                     & Operation_Character_To_String (Op3)
                     & " "
                     & Digit'Image (D)
                     & ")");
                  raise Success_Exception;
               end if;
               if (Allowed_Operation_Array (Op3)
                     (Allowed_Operation_Array (Op1)
                        (Float (A),
                         Allowed_Operation_Array (Op2) (Float (B), Float (C))),
                      Float (D)))
                 = 24.0
               then
                  Put_Line
                    ("("
                     & Digit'Image (A)
                     & " "
                     & Operation_Character_To_String (Op1)
                     & " ("
                     & Digit'Image (B)
                     & " "
                     & Operation_Character_To_String (Op2)
                     & " "
                     & Digit'Image (C)
                     & ")) "
                     & Operation_Character_To_String (Op3)
                     & " "
                     & Digit'Image (D));
                  raise Success_Exception;
               end if;
            end loop;
         end loop;
      end loop;
   end Do_Operation_Options;

   procedure Do_Permutations (Start_Index : Index := Index'First) is
   begin
      if Start_Index = Index'Last then
         Do_Operation_Options;
         return;
      end if;

      for I in Start_Index .. Index'Last loop
         Swap (Start_Index, I);
         Do_Permutations (Start_Index + 1);
         Swap (Start_Index, I);
      end loop;
   end Do_Permutations;
begin
   Put ("Enter 4 digits: ");
   declare
      Zero_Pos : constant Integer := Character'Pos ('0');
      Input    : String := Get_Line;
   begin
      if Input'Length = 4 then
         for I in Index'Range loop
            if Input (I) in '1' .. '9' then
               Digit_Array (I) := Character'Pos (Input (I)) - Zero_Pos;
            else
               Put_Line
                 ("Invalid input: all characters must be non-zero digits");
               return;
            end if;
         end loop;
      else
         Put_Line ("Invalid input: it must have length of 4");
         return;
      end if;
   end;
   Do_Permutations;
   Put_Line ("Solution not found");
exception
   when Success_Exception =>
      null;
end Game24_Solver;
