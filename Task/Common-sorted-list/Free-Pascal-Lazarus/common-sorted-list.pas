Program CommonSortedList;
{$mode ObjFPC}{$H+}

Uses sysutils,fgl;

Type
  tarr = array Of array Of integer;

Const List1: tarr = ((5,1,3,8,9,4,8,7), (3,5,9,8,4), (1,3,7,9));

Var list : specialize TFPGList<integer>;

Procedure addtolist(arr : tarr);
Var i : integer;
  arr2 : array Of integer;
Begin
  For arr2 In arr Do
    For i In arr2 Do
      If (list.indexof(i) = -1) {make sure number isn't in list already}
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
  List.Sort(@CompareInt); {quick sort the list}
  For i In list Do
    write(i:4);
  list.destroy;
End.
