with S_Of_N_Creator, Ada.Text_IO;

procedure Test_S_Of_N is

   Repetitions: constant Positive := 100_000;
   type D_10 is range 0 .. 9;

   -- the instantiation of the generic package S_Of_N_Creator generates
   -- a package with the desired functionality
   package S_Of_3 is new S_Of_N_Creator(Sample_Size => 3, Item_Type => D_10);

   Sample: S_Of_3.Item_Array;
   Result: array(D_10) of Natural := (others => 0);

begin
   for J in 1 .. Repetitions loop
      -- get Sample
      for Dig in D_10 loop
         S_Of_3.Update(Dig);
      end loop;
      Sample := S_Of_3.Result;

      -- update current Result
      for Item in Sample'Range loop
         Result(Sample(Item)) := Result(Sample(Item)) + 1;
      end loop;
   end loop;

   -- finally: output Result
   for Dig in Result'Range loop
      Ada.Text_IO.Put(D_10'Image(Dig) & ":"
                        & Natural'Image(Result(Dig)) & ";   ");
   end loop;
end Test_S_Of_N;
