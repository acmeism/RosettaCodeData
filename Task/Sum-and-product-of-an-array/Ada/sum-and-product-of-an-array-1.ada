type Int_Array is array(Integer range <>) of Integer;

array : Int_Array := (1,2,3,4,5,6,7,8,9,10);
Sum : Integer := 0;
for I in array'range loop
   Sum := Sum + array(I);
end loop;
