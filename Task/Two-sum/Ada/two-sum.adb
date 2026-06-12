with Ada.Text_IO;
use  Ada.Text_IO;

procedure Two_Sum is

   type data_arr is array (Natural range <>) of Integer;

   test1 : data_arr :=  (0, 2, 11, 19, 90);
   test2 : data_arr :=  (0, 3, 11, 19, 90);
   test3 : data_arr :=  (0, 2, 3, 3, 4, 11, 17, 17, 18, 19, 90);
   test4 : data_arr :=  (-44, 0, 0, 2, 10, 11, 19, 21, 21, 21, 65, 90);

   procedure findTwoSums (paramData : data_arr; paramSum : Integer) is
      foundSum : Boolean  := False;
   begin
      for idx in paramData'First .. (paramData'Last - 1) loop
         for jdx in (idx + 1) .. paramData'Last loop
             if paramSum = (paramData(idx) + paramData(jdx)) then
               foundSum := True;
               Put ("[" & idx'Img & jdx'Img & " ] ");
            end if;
         end loop; -- for jdx
      end loop; -- for idx
      if False = foundSum then
         Put_Line ("[]");
      else
         Put_Line ("");
      end if;
   end findTwoSums;

begin
   findTwoSums (test1, 21);
   findTwoSums (test2, 20);
   findTwoSums (test3, 21);
   findTwoSums (test4, 21);

end Two_Sum;
