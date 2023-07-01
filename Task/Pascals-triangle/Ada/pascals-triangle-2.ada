package body Pascal is

   function First_Row(Max_Length: Positive) return Row is
      R: Row(0 .. Max_Length) := (0 | 1 => 1, others => 0);
   begin
      return R;
   end First_Row;

   function Next_Row(R: Row) return Row is
      S: Row(R'Range);
   begin
      S(0) := Length(R)+1;
      S(Length(S)) := 1;
      for J in reverse 2 .. Length(R) loop
         S(J) := R(J)+R(J-1);
      end loop;
      S(1) := 1;
      return S;
   end Next_Row;

   function Length(R: Row) return Positive is
   begin
      return R(0);
   end Length;

end Pascal;
