package Tables is

   type Table is private;

   type Ordering is (Lexicographic, Psionic, ...); -- add others

   procedure Sort (It               : in out Table;
                   Order_By         : in Ordering := Lexicographic;
                   Column           : in Positive := 1;
                   Reverse_Ordering : in Boolean  := False);

private
   ... -- implementation specific
end Tables;
