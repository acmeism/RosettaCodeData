with Ada.Text_IO;

procedure Move_To_Front is

   subtype Lower_Case is Character range 'a' .. 'z';
   subtype Index is Integer range 0 .. 25;
   type Table is array (Index) of Lower_Case;
   Alphabet: constant Table := "abcdefghijklmnopqrstuvwxyz";
   type Number_String is array(Positive range <>) of Natural;

   function Encode(S: String) return Number_String is
      Key: Table := Alphabet;

      function Encode(S: String; Tab: in out Table) return Number_String is
	
	 procedure Look_Up(A: in out Table; Ch: Lower_Case; Pos: out Index) is
	 begin
	    for I in A'Range loop
	       if A(I) = Ch then
		  Pos := I;
		  A := A(Pos) & A(A'First .. Pos-1) & A(Pos+1 .. A'Last);
		  return;
	       end if;
	    end loop;
	    raise Program_Error with "unknown character";
	 end Look_Up;
	
	 Empty: Number_String(1 .. 0);
	 Result: Natural;
      begin
	 if S'Length = 0 then
	    return Empty;
	 else
	    Look_Up(Tab, S(S'First), Result);
	    return Result & Encode(S(S'First+1 .. S'Last), Tab);
	 end if;
      end Encode;

   begin
      return Encode(S, Key);
   end Encode;

   function Decode(N: Number_String) return String is
      Key: Table := Alphabet;

      function Decode(N: Number_String; Tab: in out Table) return String is
	
	 procedure Look_Up(A: in out Table; Pos: Index; Ch: out Lower_Case) is
	 begin
	    Ch := A(Pos);
	    A := A(Pos) & A(A'First .. Pos-1) & A(Pos+1 .. A'Last);
	 end Look_Up;
	
	 Result: String(N'Range);
      begin
	 for I in N'Range loop
	    Look_Up(Tab, N(I), Result(I));
	 end loop;
	 return Result;
      end Decode;

   begin
      return Decode(N, Key);
   end Decode;

   procedure Encode_Write_Check(S: String) is
      N: Number_String := Encode(S);
      T: String := Decode(N);
      Check: String := (if S=T then "Correct!" else "*WRONG*!");
   begin
      Ada.Text_IO.Put("'" & S & "' encodes to");
      for Num of N loop
	 Ada.Text_IO.Put(Integer'Image(Num));
      end loop;
      Ada.Text_IO.Put_Line(". This decodes to '" & T & "'. " & Check);
   end Encode_Write_Check;

begin
   Encode_Write_Check("broood");
   Encode_Write_Check("bananaaa");
   Encode_Write_Check("hiphophiphop");
end Move_To_Front;
