with Ada.Text_IO, Ada.Containers.Generic_Array_Sort;

procedure Largest_Int_From_List is

   function Img(N: Natural) return String is
      S: String := Integer'Image(N);
   begin
      return S(S'First+1 .. S'Last); -- First character is ' '
   end Img;

   function Order(Left, Right: Natural) return Boolean is
      ( (Img(Left) & Img(Right)) > (Img(Right) & Img(Left)) );

   type Arr_T is array(Positive range <>) of Natural;

   procedure Sort is new Ada.Containers.Generic_Array_Sort
     (Positive, Natural, Arr_T, Order);

   procedure Print_Sorted(A: Arr_T) is
      B: Arr_T := A;
   begin
      Sort(B);
      for Number of B loop
	 Ada.Text_IO.Put(Img(Number));
      end loop;
      Ada.Text_IO.New_Line;
   end Print_Sorted;

begin
   Print_Sorted((1, 34, 3, 98, 9, 76, 45, 4));
   Print_Sorted((54, 546, 548, 60));
end Largest_Int_From_List;
