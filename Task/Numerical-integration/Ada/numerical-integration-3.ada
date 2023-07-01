with Ada.Text_IO, Ada.Integer_Text_IO;
with Integrate;

procedure Numerical_Integration is
   type Scalar is digits 18;
   package Scalar_Text_IO is new Ada.Text_IO.Float_IO (Scalar);

   generic
      with function F (X : Scalar) return Scalar;
      Name     : String;
      From, To : Scalar;
      Steps    : Positive;
   procedure Test;

   procedure Test is
      package Integrate_Scalar_F is new Integrate (Scalar, F);
      use Ada.Text_IO, Ada.Integer_Text_IO, Integrate_Scalar_F, Scalar_Text_IO;
   begin
      Put (Name & " integrated from ");
      Put (From);
      Put (" to ");
      Put (To);
      Put (" in ");
      Put (Steps);
      Put_Line (" steps:");

      Put ("Rectangular (left):     ");
      Put (Left_Rectangular (From, To, Steps));
      New_Line;

      Put ("Rectangular (right):    ");
      Put (Right_Rectangular (From, To, Steps));
      New_Line;

      Put ("Rectangular (midpoint): ");
      Put (Midpoint_Rectangular (From, To, Steps));
      New_Line;

      Put ("Trapezium:              ");
      Put (Trapezium (From, To, Steps));
      New_Line;

      Put ("Simpson's:              ");
      Put (Simpsons (From, To, Steps));
      New_Line;

      New_Line;
   end Test;
begin
   Ada.Integer_Text_IO.Default_Width := 0;
   Scalar_Text_IO.Default_Fore := 0;
   Scalar_Text_IO.Default_Exp  := 0;

Cubed:
   declare
      function F (X : Scalar) return Scalar is
      begin
         return X ** 3;
      end F;
      procedure Run is new Test (F     => F,
                                 Name  => "x^3",
                                 From  => 0.0,
                                 To    => 1.0,
                                 Steps => 100);
   begin
      Run;
   end Cubed;

One_Over_X:
   declare
      function F (X : Scalar) return Scalar is
      begin
         return 1.0 / X;
      end F;
      procedure Run is new Test (F     => F,
                                 Name  => "1/x",
                                 From  => 1.0,
                                 To    => 100.0,
                                 Steps => 1_000);
   begin
      Run;
   end One_Over_X;

X:
   declare
      function F (X : Scalar) return Scalar is
      begin
         return X;
      end F;
      procedure Run_1 is new Test (F     => F,
                                   Name  => "x",
                                   From  => 0.0,
                                   To    => 5_000.0,
                                   Steps => 5_000_000);
      procedure Run_2 is new Test (F     => F,
                                   Name  => "x",
                                   From  => 0.0,
                                   To    => 6_000.0,
                                   Steps => 6_000_000);
   begin
      Run_1;
      Run_2;
   end X;
end Numerical_Integration;
