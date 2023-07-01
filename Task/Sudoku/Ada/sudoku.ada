with Ada.Text_IO;

procedure Sudoku is
   type sudoku_ar_t is array ( integer range 0..80 ) of integer range 0..9;
   FINISH_EXCEPTION : exception;

   procedure prettyprint(sudoku_ar: sudoku_ar_t);
   function checkValidity( val : integer; x : integer; y : integer;  sudoku_ar: in  sudoku_ar_t) return Boolean;
   procedure placeNumber(pos: Integer; sudoku_ar: in out sudoku_ar_t);
   procedure solve(sudoku_ar: in out sudoku_ar_t);


   function checkValidity( val : integer; x : integer; y : integer;  sudoku_ar: in  sudoku_ar_t) return Boolean
   is
   begin
      for i in 0..8 loop

         if ( sudoku_ar( y * 9 + i ) = val or sudoku_ar( i * 9 + x ) = val ) then
            return False;
         end if;
      end loop;

      declare
         startX : constant integer := ( x / 3 ) * 3;
         startY : constant integer := ( y / 3 ) * 3;
      begin
         for i in startY..startY+2 loop
            for j in startX..startX+2 loop
               if ( sudoku_ar( i * 9 +j ) = val ) then
                  return False;
               end if;
            end loop;
         end loop;
         return True;
      end;
   end checkValidity;



   procedure placeNumber(pos: Integer; sudoku_ar: in out sudoku_ar_t)
   is
   begin
      if ( pos = 81 ) then
         raise FINISH_EXCEPTION;
      end if;
      if (  sudoku_ar(pos) > 0 ) then
         placeNumber(pos+1, sudoku_ar);
         return;
      end if;
      for n in 1..9 loop
         if( checkValidity( n,  pos mod 9, pos / 9 , sudoku_ar ) ) then
            sudoku_ar(pos) := n;
            placeNumber(pos + 1, sudoku_ar );
            sudoku_ar(pos) := 0;
         end if;
      end loop;
   end placeNumber;


   procedure solve(sudoku_ar: in out sudoku_ar_t)
   is
   begin
      placeNumber( 0, sudoku_ar );
      Ada.Text_IO.Put_Line("Unresolvable !");
   exception
      when FINISH_EXCEPTION =>
         Ada.Text_IO.Put_Line("Finished !");
         prettyprint(sudoku_ar);
   end solve;




   procedure prettyprint(sudoku_ar: sudoku_ar_t)
   is
      line_sep   : constant String  := "------+------+------";
   begin
      for i in sudoku_ar'Range loop
         Ada.Text_IO.Put(sudoku_ar(i)'Image);
         if (i+1) mod 3 = 0 and not((i+1) mod 9 = 0) then
            Ada.Text_IO.Put("|");
         end if;
         if (i+1) mod 9 = 0 then
            Ada.Text_IO.Put_Line("");
         end if;
         if (i+1) mod 27 = 0 then
            Ada.Text_IO.Put_Line(line_sep);
         end if;
      end loop;
   end prettyprint;


   sudoku_ar : sudoku_ar_t :=
     (
      8,5,0,0,0,2,4,0,0,
      7,2,0,0,0,0,0,0,9,
      0,0,4,0,0,0,0,0,0,
      0,0,0,1,0,7,0,0,2,
      3,0,5,0,0,0,9,0,0,
      0,4,0,0,0,0,0,0,0,
      0,0,0,0,8,0,0,7,0,
      0,1,7,0,0,0,0,0,0,
      0,0,0,0,3,6,0,4,0
     );

begin
   solve( sudoku_ar );
end Sudoku;
