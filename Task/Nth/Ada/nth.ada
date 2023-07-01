with Ada.Text_IO;

procedure Nth is

   function Suffix(N: Natural) return String is
   begin
      if    N mod 10 = 1 and then N mod 100 /= 11 then return "st";
      elsif N mod 10 = 2 and then N mod 100 /= 12 then return "nd";
      elsif N mod 10 = 3 and then N mod 100 /= 13 then return "rd";
      else return "th";
      end if;
   end Suffix;

   procedure Print_Images(From, To: Natural) is
   begin
      for I in From .. To loop
	 Ada.Text_IO.Put(Natural'Image(I) & Suffix(I));
      end loop;
      Ada.Text_IO.New_Line;
   end Print_Images;

begin
   Print_Images(   0,   25);
   Print_Images( 250,  265);
   Print_Images(1000, 1025);
end Nth;
