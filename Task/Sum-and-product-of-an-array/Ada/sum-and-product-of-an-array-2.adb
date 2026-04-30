function Product(Item : Int_Array) return Integer is
  Prod : Integer := 1;
begin
  for I in Item'range loop
     Prod := Prod * Item(I);
  end loop;
  return Prod;
end Product;
