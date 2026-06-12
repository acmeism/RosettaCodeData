program SinglyLinkedList;

type
  TLinkedList = object
  private
    type
      PLink = ^TLink;
      TLink = record
        FNext: PLink;
        FData: Integer;
      end;
  private
    Head: PLink;
  public
    constructor Init;
    destructor Done;

    procedure Add(Value: Integer);
    procedure Delete(Value: Integer);
    procedure Print;
  end;

constructor TLinkedList.Init;
begin
  Head := nil;
end;

destructor TLinkedList.Done;
var
  Temp: PLink;
begin
  while Head <> nil do
  begin
    Temp := Head;
    Head := Head^.FNext;
    Dispose(Temp);
  end;
end;

procedure TLinkedList.Add(Value: Integer);
var
  NewLink, Temp: PLink;
begin
  New(NewLink);
  NewLink^.FData := Value;
  NewLink^.FNext := nil;

  if Head = nil then
    Head := NewLink
  else
  begin
    Temp := Head;
    while Temp^.FNext <> nil do
      Temp := Temp^.FNext;
    Temp^.FNext := NewLink;
  end;
end;

procedure TLinkedList.Delete(Value: Integer);
var
  Temp, Prev: PLink;
begin
  Temp := Head;
  Prev := nil;

  while Temp <> nil do
  begin
    if Temp^.FData = Value then
    begin
      if Prev = nil then
        Head := Temp^.FNext
      else
        Prev^.FNext := Temp^.FNext;

      Dispose(Temp);
      Exit;
    end;
    Prev := Temp;
    Temp := Temp^.FNext;
  end;
end;

procedure TLinkedList.Print;
var
  Temp: PLink;
begin
  Temp := Head;
  while Temp <> nil do
  begin
    Write(Temp^.FData, ' ');
    Temp := Temp^.FNext;
  end;
  Writeln;
end;

var
  List: TLinkedList;

begin
  List.Init;

  List.Add(10);
  List.Add(20);
  List.Add(30);
  List.Add(40);

  Writeln('Original List:');
  List.Print;
  Writeln('Deleting 20...');
  List.Delete(20);
  Writeln('Updated List:');
  List.Print;
  List.Done;
end.

