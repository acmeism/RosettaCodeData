with Ada.Text_Io; use Ada.Text_Io;
with Numeric_Tests; use Numeric_Tests;

procedure Is_Numeric_Test is
   S1 : String := "152";
   S2 : String := "-3.1415926";
   S3 : String := "Foo123";
begin
   Put_Line(S1 & " results in " & Boolean'Image(Is_Numeric(S1)));
   Put_Line(S2 & " results in " & Boolean'Image(Is_Numeric(S2)));
   Put_Line(S3 & " results in " & Boolean'Image(Is_Numeric(S3)));
end Is_Numeric_Test;
