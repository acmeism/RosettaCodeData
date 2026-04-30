with Ada.Text_IO; use Ada.Text_IO;

procedure Thue_Morse is

   function Replace(S: String) return String is
      -- replace every "0" by "01" and every "1" by "10"
      (if S'Length = 0 then ""
      else (if S(S'First) = '0' then "01" else "10") &
	Replace(S(S'First+1 .. S'Last)));

   function Sequence (N: Natural) return String is
      (if N=0 then "0" else Replace(Sequence(N-1)));

begin
   for I in 0 .. 6 loop
      Ada.Text_IO.Put_Line(Integer'Image(I) & ": " & Sequence(I));
   end loop;
end Thue_Morse;
