Program SortedSquares;
{$mode ObjFPC}{$H+}

Uses sysutils,fgl;

Type
  tmap = specialize TFPGList<integer>;

Const List1: array Of integer = (3,4,34,25,9,12,36,56,36);
Const List2: array Of integer = (2,8,81,169,34,55,76,49,7);
Const List3: array Of integer = (75,121,75,144,35,16,46,35);

Var list : specialize TFPGList<integer>;

Procedure addtolist(arr : Array Of integer);
Var i : integer;
Begin
  For i In arr Do
    If ((frac(sqrt(i)) = 0) {check if a square, there will be no fraction}
       And (list.indexof(i) = -1)) {make sure number isn't in list already}
      Then list.add(i);
End;

Function CompareInt(Const Item1,Item2: Integer): Integer;
Begin
  result := item1 - item2;
End;

Var i : integer;
Begin
  list := specialize TFPGList<integer>.create;
  addtolist(list1);
  addtolist(list2);
  addtolist(list3);
  List.Sort(@CompareInt); {quick sort the list}
  For i In list Do
    write(i:4);
  list.destroy;
End.
