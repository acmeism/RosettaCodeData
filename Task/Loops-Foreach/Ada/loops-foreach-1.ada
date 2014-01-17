with Ada.Integer_Text_IO;
use  Ada.Integer_Text_IO;

procedure For_Each is

   A : array (1..5) of Integer := (-1, 0, 1, 2, 3);

begin

   for Num in A'Range loop
      Put( A (Num) );
   end loop;

end For_Each;
