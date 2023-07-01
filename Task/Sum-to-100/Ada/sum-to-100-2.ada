with Ada.Text_IO, Ada.Containers.Ordered_Maps;

package body Sum_To is

   procedure Eval is

      procedure Rec_Eval(Str: String; Previous, Current, Next: Integer) is
	 Next_Image: String := Integer'Image(Next);
	 -- Next_Image(1) holds a blank, Next_Image(2) a digit
	
	 function Sign(N: Integer) return Integer is
	    (if N<0 then -1 elsif N>0 then 1 else 0);
	
      begin
	 if Next = 10 then -- end of recursion
	    Callback(Str, Previous+Current);
	 else -- Next < 10
	    Rec_Eval(Str & Next_Image(2), -- concatenate current and Next
		 Previous, Sign(Current)*(10*abs(Current)+Next), Next+1);
	    Rec_Eval(Str & "+" & Next_Image(2), -- add Next
		 Previous+Current, Next, Next+1);
	    Rec_Eval(Str & "-" & Next_Image(2), -- subtract Next
		 Previous+Current, -Next, Next+1);
	 end if;
      end Rec_Eval;

   begin -- Eval
      Rec_Eval("1", 0, 1, 2);  -- unary "+", followed by "1"
      Rec_Eval("-1", 0, -1, 2); -- unary "-", followed by "1"
   end Eval;

   procedure Print(S: String; Sum: Integer) is
      -- print solution (S,N), if N=Number
   begin
      if Print_If(Sum, Number) then
	 Ada.Text_IO.Put_Line(Integer'Image(Sum) & " = " & S & ";");
      end if;
   end Print;

end Sum_To;
