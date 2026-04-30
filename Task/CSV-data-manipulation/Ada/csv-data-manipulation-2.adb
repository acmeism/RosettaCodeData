package body CSV is

   function Line(S: String; Separator: Character := ',')
                return Row is
      (Length => S'Length, Str => S,
       Fst => S'First, Lst => S'Last, Nxt => S'First, Sep => Separator);

   function Item(R: Row) return String is
      (R.Str(R.Fst .. R.Lst));

   function Next(R: in out Row) return Boolean is
      Last: Natural := R.Nxt;
   begin
      R.Fst := R.Nxt;
      while Last <= R.Str'Last and then R.Str(Last) /= R.Sep loop
         -- find Separator
         Last := Last + 1;
      end loop;
      R.Lst := Last - 1;
      R.Nxt := Last + 1;
      return (R.Fst <= R.Str'Last);
   end Next;

end CSV;
