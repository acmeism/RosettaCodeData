package CSV is

   type Row(<>) is tagged private;

   function Line(S: String; Separator: Character := ',') return Row;
   function Next(R: in out Row) return Boolean;
     -- if there is still an item in R, Next advances to it and returns True
   function Item(R: Row) return String;
     -- after calling R.Next i times, this returns the i'th item (if any)

private
   type Row(Length: Natural) is tagged record
      Str: String(1 .. Length);
      Fst: Positive;
      Lst: Natural;
      Nxt: Positive;
      Sep: Character;
   end record;
end CSV;
