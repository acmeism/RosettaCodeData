package Pascal is

   type Row is array (Natural range <>) of Natural;

   function Length(R: Row) return Positive;

   function First_Row(Max_Length: Positive) return Row;

   function Next_Row(R: Row) return Row;

end Pascal;
