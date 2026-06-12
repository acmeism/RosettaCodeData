{Simple iterator based around a string collection}
{The details of string storage are hidden from the user}
{Strings are only accessible through the supplied interface}

type TStringIterator = class(TObject)
 private
  Collection: TStringList;
  Index: integer;
 protected
 public
  constructor Create;
  destructor Destroy; override;
  procedure Add(S: string);
  procedure Insert(const Item, Before: string);
  procedure Remove(const Item: string);
  procedure Clear;
  function Contains(const Item: string): Boolean;
  function GetCount: Integer;
  procedure Reset;
  function Next: Boolean;
  function Previous: Boolean;
  procedure Last;
  function CurrentItem: string;
  procedure LoadArray(SA: array of string);
 end;

{ TStringIterator }

procedure TStringIterator.Add(S: string);
{Add item to Collection}
begin
Collection.Add(S);
end;

procedure TStringIterator.Clear;
{Clear collection}
begin
Collection.Clear;
end;

function TStringIterator.Contains(const Item: string): Boolean;
{Test if string is in collection}
begin
Result:=Collection.IndexOf(Item)>=0;
end;

constructor TStringIterator.Create;
{Create collection and initialize}
begin
Collection:=TStringList.Create;
Clear;
Reset;
end;


function TStringIterator.CurrentItem: string;
{Return current item from collection}
begin
Result:=Collection[Index];
end;

destructor TStringIterator.Destroy;
{Dispose of collection}
begin
Collection.Free;
inherited;
end;


function TStringIterator.GetCount: Integer;
{Return count of items in collection}
begin
Result:=Collection.Count;
end;

procedure TStringIterator.Insert(const Item, Before: string);
{Insert item in collection before specified item}
{If "Before" isn't found, insert at end of collection}
var Inx: integer;
begin
if Before='' then Collection.Add(Item)
else
	begin
	Inx:=Collection.IndexOf(Before);
	if Inx>=0 then Collection.Insert(Inx,Item);
	end
end;

function TStringIterator.Next: Boolean;
{Point to next item in collection}
{Return false if no more items in collection}
begin
Result:=(Index<Collection.Count-1);
if Result then Inc(Index);
end;

function TStringIterator.Previous: Boolean;
{Point to previous item in collection}
{Return false if no more Previous items in collection}
begin
Result:=(GetCount>0) and (Index>0);
if Result then Dec(Index);
end;


procedure TStringIterator.Remove(const Item: string);
{Remove specified item from list}
var Inx: integer;
begin
Inx:=Collection.IndexOf(Item);
if Inx>=0 then Collection.Delete(Inx);
end;

procedure TStringIterator.Reset;
{Point to start of collection}
begin
Index:=0;
end;

procedure TStringIterator.Last;
{Point to Last item in collection}
begin
Index:=Collection.Count-1;
end;



procedure TStringIterator.LoadArray(SA: array of string);
{Load array of strings into Collection}
var I: integer;
begin
for I:=0 to High(SA) do Add(SA[I]);
end;


{-----------------------------------------------------------}


procedure TestIterator(Memo: TMemo);
var WeekDays,Colors: TStringIterator;

	function Traverse(Iter: TStringIterator): string;
	begin
	Iter.Reset;
	Result:='';
	repeat Result:=Result+Iter.CurrentItem+' ';
	until not Iter.Next;
	end;

	function FirstFourthFifth(Iter: TStringIterator): string;
	var I: integer;
	begin
	Iter.Reset;
	Result:='';
	Result:=Result+Iter.CurrentItem+' ';
	for I:=1 to 3 do Iter.Next;
	Result:=Result+Iter.CurrentItem+' ';
        Iter.Next;
        Result:=Result+Iter.CurrentItem+' ';
	end;

	function LastFourthFifth(Iter: TStringIterator): string;
	var I: integer;
	begin
	Iter.Last;
	Result:='';
	Result:=Result+Iter.CurrentItem+' ';
	for I:=1 to 3 do Iter.Previous;
	Result:=Result+Iter.CurrentItem+' ';
        Iter.Previous;
        Result:=Result+Iter.CurrentItem+' ';
	end;

begin
WeekDays:=TStringIterator.Create;
try
Colors:=TStringIterator.Create;
try
WeekDays.LoadArray(['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday']);
Colors.LoadArray(['Red','Orange','Yellow','Green','Blue','Purple']);

Memo.Lines.Add(Traverse(Weekdays));
Memo.Lines.Add(Traverse(Colors));
Memo.Lines.Add(FirstFourthFifth(Weekdays));
Memo.Lines.Add(FirstFourthFifth(Colors));
Memo.Lines.Add(LastFourthFifth(Weekdays));
Memo.Lines.Add(LastFourthFifth(Colors));

finally Colors.Free; end;
finally WeekDays.Free; end;
end;

