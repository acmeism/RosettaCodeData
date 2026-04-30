with Ada.Text_IO;

procedure Catamorphism is

   type Fun is access function (Left, Right: Natural) return Natural;
   type Arr is array(Natural range <>) of Natural;

   function Fold_Left (F: Fun; A: Arr) return Natural is
      Result: Natural := A(A'First);
   begin
      for I in A'First+1 .. A'Last loop
	 Result := F(Result, A(I));
      end loop;
      return Result;
   end Fold_Left;

   function Max (L, R: Natural) return Natural is (if L > R then L else R);
   function Min (L, R: Natural) return Natural is (if L < R then L else R);
   function Add (Left, Right: Natural) return Natural is (Left + Right);
   function Mul (Left, Right: Natural) return Natural is (Left * Right);

   package NIO is new Ada.Text_IO.Integer_IO(Natural);

begin
   NIO.Put(Fold_Left(Min'Access, (1,2,3,4)), Width => 3);
   NIO.Put(Fold_Left(Max'Access, (1,2,3,4)), Width => 3);
   NIO.Put(Fold_Left(Add'Access, (1,2,3,4)), Width => 3);
   NIO.Put(Fold_Left(Mul'Access, (1,2,3,4)), Width => 3);
end Catamorphism;
