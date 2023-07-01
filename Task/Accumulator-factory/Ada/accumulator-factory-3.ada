package body Accumulator is

--  The accumulator lives through three states. It is in Virgin_State
--  before any use of The_Function. It changes to Integer_State or
--  Float_State, according to the input type used. The accumulation is
--  memorized in variable I or F, according to the state. Float_State,
--  once reached, is never left. A Float output on an Integer_State is
--  simply a conversion, sans effect on state. (Marius Amado-Alves)

   type State_T is (Virgin_State, Integer_State, Float_State);
   State : State_T := Virgin_State;
   I : Integer;
   F : Float;

   function The_Function (X : Float) return Float is
   begin
      case State is
         when Virgin_State =>
            State := Float_State;
            F := X;
            return F;
         when Integer_State =>
            State := Float_State;
            F := Float (I) + X;
            return F;
         when Float_State =>
            F := F + X;
            return F;
      end case;
   end;

   function The_Function (X : Integer) return Float is
   begin
      case State is
         when Virgin_State =>
            State := Integer_State;
            I := X;
            return Float (I);
         when Integer_State =>
            I := I + X;
            return Float (I);
         when Float_State =>
            F := F + Float (X);
            return F;
      end case;
   end;

   function The_Function (X : Integer) return Integer is
   begin
      case State is
         when Virgin_State =>
            State := Integer_State;
            I := X;
            return I;
         when Integer_State =>
            I := I + X;
            return I;
         when Float_State =>
            F := F + Float (X);
            return Integer (F);
      end case;
   end;

end;
