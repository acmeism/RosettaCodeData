with Printable_Calendar;

procedure Cal is

   C: Printable_Calendar.Calendar := Printable_Calendar.Init_80;

begin
   C.Print_Line_Centered("[reserved for Snoopy]");
   C.New_Line;
   C.Print(1969, "Nineteen-Sixty-Nine");
end Cal;
