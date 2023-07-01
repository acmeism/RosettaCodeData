program Menu;
{$ASSERTIONS ON}
uses
  objects;
var
  MenuItems :PUnSortedStrCollection;
  selected  :string;

Function SelectMenuItem(MenuItems :PUnSortedStrCollection):string;
var
  i, idx :integer;
  code   :word;
  choice :string;
begin
  // Return empty string if the collection is empty.
  if MenuItems^.Count = 0 then
  begin
    SelectMenuItem := '';
    Exit;
  end;

  repeat
    for i:=0 to MenuItems^.Count-1 do
    begin
      writeln(i+1:2, ') ', PString(MenuItems^.At(i))^);
    end;
    write('Make your choice: ');
    readln(choice);
    // Try to convert choice to an integer.
    // Code contains 0 if this was successful.
    val(choice, idx, code)
  until (code=0) and (idx>0) and (idx<=MenuItems^.Count);
  // Return the selected element.
  SelectMenuItem := PString(MenuItems^.At(idx-1))^;
end;

begin
  // Create an unsorted string collection for the menu items.
  MenuItems := new(PUnSortedStrCollection, Init(10, 10));

  // Add some menu items to the collection.
  MenuItems^.Insert(NewStr('fee fie'));
  MenuItems^.Insert(NewStr('huff and puff'));
  MenuItems^.Insert(NewStr('mirror mirror'));
  MenuItems^.Insert(NewStr('tick tock'));

  // Display the menu and get user input.
  selected := SelectMenuItem(MenuItems);
  writeln('You chose: ', selected);

  dispose(MenuItems, Done);

  // Test function with an empty collection.
  MenuItems := new(PUnSortedStrCollection, Init(10, 10));

  selected := SelectMenuItem(MenuItems);
  // Assert that the function returns an empty string.
  assert(selected = '', 'Assertion failed: the function did not return an empty string.');

  dispose(MenuItems, Done);
end.
