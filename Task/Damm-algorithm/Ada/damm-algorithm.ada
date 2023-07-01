with Ada.Text_IO;

procedure Damm_Algorithm is

   function Damm (Input : in String) return Boolean
   is
      subtype Digit is Character range '0' .. '9';

      Table : constant array (Digit, Digit) of Digit :=
        (('0', '3', '1', '7', '5', '9', '8', '6', '4', '2'),
         ('7', '0', '9', '2', '1', '5', '4', '8', '6', '3'),
         ('4', '2', '0', '6', '8', '7', '1', '3', '5', '9'),
         ('1', '7', '5', '0', '9', '8', '3', '4', '2', '6'),
         ('6', '1', '2', '3', '0', '4', '5', '9', '7', '8'),
         ('3', '6', '7', '4', '2', '0', '9', '5', '8', '1'),
         ('5', '8', '6', '9', '7', '2', '0', '1', '3', '4'),
         ('8', '9', '4', '5', '3', '6', '2', '0', '1', '7'),
         ('9', '4', '3', '8', '6', '1', '7', '2', '0', '5'),
         ('2', '5', '8', '1', '4', '3', '6', '7', '9', '0'));
      Intern : Digit := '0';
   begin
      for D of Input loop
         Intern := Table (Intern, D);
      end loop;
      return Intern = '0';
   end Damm;

   procedure Put_Damm (Input : in String) is
      use Ada.Text_IO;
   begin
      Put_Line ("Damm of " & Input & " validates as " & Damm (Input)'Image);
   end Put_Damm;

begin
   Put_Damm ("5724");
   Put_Damm ("5727");
   Put_Damm ("112946");
   Put_Damm ("112949");
end Damm_Algorithm;
