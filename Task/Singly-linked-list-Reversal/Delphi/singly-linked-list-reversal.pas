unit ReverseList;

interface

uses StdCtrls;

procedure LinkListTest(Memo: TMemo);

implementation

{}

const TestData: array [0..5] of string = ('Big','fjords','vex','quick','waltz','nymph');

{Structure contains one list item}

type TLinkItem = record
 Name: string;
 Link: integer;
 end;

{Define a dynamic array, linked list type}

type TLinkedList = array of TLinkItem;

{Define actual working linked-list}

var LinkedList: TLinkedList;


procedure AddItem(var LL: TLinkedList; S: string);
{Insert one string in the specified Linked List}
var Inx: integer;
begin
SetLength(LL,Length(LL)+1);
Inx:=High(LL);
LL[Inx].Name:=S;
LL[Inx].Link:=-1;
{if not first entry, link to previous entry}
if Inx>0 then LL[Inx-1].Link:=Inx;
end;



function GetReversedList(LL: TLinkedList): TLinkedList;
{Return the reverse of the input list}
var I,Next: integer;
var SA: array of string;
begin
SetLength(SA,Length(LL));
{Get names in linked order}
Next:=0;
for I:=0 to High(LL) do
	begin
	SA[I]:=LL[Next].Name;
	Next:=LL[Next].Link;
	end;
{Insert them in Linked List in reverse order}
for I:=High(SA) downto 0 do AddItem(Result,SA[I]);
end;


function ListToStr(LL: TLinkedList): string;
{Return list as string for printing or display}
var I,Next: integer;
begin
Result:='';
Next:=0;
for I:=0 to High(LL) do
	begin
	Result:=Result+LL[Next].Name+' ';
	Next:=LL[Next].Link;
	end;
end;


procedure LinkListTest(Memo: TMemo);
{Routine to test the code}
{returns output string in memo}
var I: integer;
var S: string;
var LL: TLinkedList;
begin
Memo.Clear;
for I:=0 to High(TestData) do AddItem(LinkedList,TestData[I]);
Memo.Lines.Add(ListToStr(LinkedList));
LL:=GetReversedList(LinkedList);
Memo.Lines.Add(ListToStr(LL));
end;

end.
