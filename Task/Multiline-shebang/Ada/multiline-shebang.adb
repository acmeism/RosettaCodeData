#!/bin/bash
sed -n -e '7,$p' < "$0" > mulshbang.adb
gnatmake -q mulshbang
./mulshbang $*
rm mulshbang*
exit
with Ada.Text_IO, Ada.Command_Line; -- first line of Ada program

procedure Mulshbang is
  use Ada.Text_IO;
begin
  Put_Line("Name: " & Ada.Command_Line.Command_Name);
  for I in 1 .. Ada.Command_Line.Argument_Count loop
    Put_Line("  Arg" & Integer'Image(I) & ": " &
             Ada.Command_Line.Argument(I));
  end loop;
end Mulshbang;
