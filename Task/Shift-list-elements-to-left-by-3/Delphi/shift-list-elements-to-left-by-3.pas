program Shift_list_elements_to_left_by_3;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Boost.Int;

var
  List: TArray<Integer>;

begin
  List := [1, 2, 3, 4, 5, 6, 7, 8, 9];
  writeln('Original list     :', list.ToString);
  List.shift(3);
  writeln('Shifted left by 3 :', list.ToString);
  Readln;
end.
