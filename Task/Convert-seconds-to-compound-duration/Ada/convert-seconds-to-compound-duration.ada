with Ada.Text_IO;

procedure Convert is

   type Time is range 0 .. 10_000*356*20*60*60; -- at most 10_000 years
   subtype Valid_Duration is Time range 1  .. 10_000*356*20*60*60;
   type Units is (WK, D, HR, MIN, SEC);

   package IO renames Ada.Text_IO;

   Divide_By: constant array(Units) of Time := (1_000*53, 7, 24, 60, 60);
   Split: array(Units) of Time;
   No_Comma: Units;
   X: Time;

   Test_Cases: array(Positive range <>) of Valid_Duration :=
     (6, 60, 3659, 7_259, 86_400, 6_000_000, 6_001_200, 6_001_230, 600_000_000);

begin
  for Test_Case of Test_Cases loop
     IO.Put(Time'Image(Test_Case) & " SECONDS =");
     X := Test_Case;
	
     -- split X up into weeks, days, ..., seconds
     No_Comma := Units'First;
     for Unit in reverse Units loop -- Unit = SEC, ..., WK (in that order)
	Split(Unit) := X mod Divide_By(Unit);
	X := X / Divide_By(Unit);
	if Unit > No_Comma and Split(Unit)>0 then
	   No_Comma := Unit;
	end if;
     end loop;
	
     -- ouput weeks, days, ..., seconds
     for Unit in Units loop -- Unit =  WK, .., SEC (in that order)
	if Split(Unit) > 0 then
	   IO.Put(Time'Image(Split(Unit)) & " " & Units'Image(Unit) &
		    (if No_Comma > Unit then "," else ""));
	end if;
     end loop;

  IO.New_Line;
  end loop;
end Convert;
