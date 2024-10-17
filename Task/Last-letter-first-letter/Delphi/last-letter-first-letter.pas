unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DBCtrls, DB, DBClient, Grids, DBGrids, ExtCtrls;

type
  TLastLFirstL = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1Longitud: TIntegerField;
    ClientDataSet1Cantidad: TIntegerField;
    ClientDataSet1Lista: TMemoField;
    Panel2: TPanel;
    DBMemo1: TDBMemo;
    DBGrid1: TDBGrid;
    Splitter1: TSplitter;
    CheckBox1: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPokemons:TStrings; //internal list of words, taken from memo
    FIndex:TStrings; //index of words, based on starting letter
    FCurrList:TStrings; //current list of words being made
    FMax:integer; //max length of list found so far
    FCount:array of array[boolean]of integer; //counting of lists length ocurrences
  protected
    procedure BuildIndex; //build FIndex based on FPokemons contents
    procedure ClearIndex; //empty FIndex
    procedure PokeChain(starting:Char;mylevel:integer); //recursive procedure that builds words lists
    procedure BuildChains; //starts the lists building, by calling PokeChain for every FPokemons
    procedure AddCurrList; //called each time a list is "finished" (no more words to add to it)
  public
    { Public declarations }
  end;

var
  LastLFirstL: TLastLFirstL;

implementation

{$R *.dfm}

{ TForm1 }

{ if the actual list is the longest found so far it is added to
the dataset, otherwise its ocurrence is just counted}
procedure TLastLFirstL.AddCurrList;
var
  i,cc: integer;
  foundit:boolean;
begin
  with ClientDataSet1 do begin
    cc := FCurrList.Count;
    if cc <= FMax then begin //count it
      foundit := false;
      for i := 0 to High(FCount) do begin
        foundit := FCount[i][false] = cc;
        if foundit then begin
          FCount[i][true] := FCount[i][true] + 1;
          break;
        end;
      end;
      if not foundit then begin
        //length that we never add to the dataset
        i := High(FCount);
        SetLength(FCount,i+2);
        Inc(i);
        FCount[i][false] := cc;
        FCount[i][true] := 1;
      end;
      exit;
    end;
    //new longest list is FCurrList, add it to the dataset
    FMax := cc;
    SetLength(FCount,High(Fcount)+2); //make room for ocurrence count
    FCount[High(FCount)][false] := cc;
    FCount[High(FCount)][true] := 1;
    //actual dataset adding
    Append;
    Fields[0].AsInteger := cc;
    Fields[1].AsInteger := 0;
    Fields[2].AsString := FCurrList.Text; //first one is example one
    Post;
  end;
end;

{}
procedure TLastLFirstL.BuildChains;
var
  stSeen:array of array[boolean] of char;
  poke:string;
  i:integer;
  tc:int64;
  filteqs:boolean;
  k: Integer;
begin
  //do some cleaning before starting
  while not ClientDataSet1.IsEmpty do
    ClientDataSet1.Delete;
  Finalize(FCount);
  FMax := 0;
  filteqs := CheckBox1.Checked;
  //measure time
  tc := gettickcount;
  //each word is given the opportunity of starting a list
  if filteqs then begin
    //ignore words with same start and end as others already seen
    filteqs := False;
    for i := 0 to FPokemons.Count - 1 do begin
      poke := FPokemons[i];
      for k := 0 to High(stSeen) do begin
        filteqs := (stSeen[k][false] = poke[1]) and (stSeen[k][true] = poke[length(poke)]);
        if filteqs then
          break;
      end;
      if filteqs then //already seen equivalent
        continue;
      FPokemons.Objects[i] := Pointer(1);
      FCurrList.Clear; //new list of words
      FCurrList.Add(poke);
      PokeChain(poke[length(poke)],2); //continue the list
      //register as seen, for future equivalents
      k := High(stSeen);
      SetLength(stSeen,k+2);
      Inc(k);
      stSeen[k][false] := poke[1];
      stSeen[k][true] := poke[length(poke)];
      FPokemons.Objects[i] := nil;
    end;
    Finalize(stSeen);
  end else begin
    for i := 0 to FPokemons.Count - 1 do begin
      poke := FPokemons[i];
      FPokemons.Objects[i] := Pointer(1);
      FCurrList.Clear; //new list of words
      FCurrList.Add(poke);
      PokeChain(poke[length(poke)],2); //continue the list
      FPokemons.Objects[i] := nil;
    end;
  end;
  tc := gettickcount - tc; //don't consider dataset counting as part of the process
  //set actual counting of ocurrences on the dataset
  for i := 0 to High(FCount) do with ClientDataSet1 do begin
    if Locate('Longitud',FCount[i][false],[]) then
      Edit
    else begin
      Append;
      Fields[0].AsInteger := FCount[i][false];
      Fields[2].AsString := 'No example preserved';
    end;
    Fields[1].AsInteger := FCount[i][true];
    Post;
  end;
  ClientDataSet1.IndexFieldNames := 'Longitud';
  //show time taken
  Panel1.Caption := IntToStr(tc div 1000) + '.' + IntToStr(tc - (tc div 1000) * 1000) + ' segs.';
end;

{ builds an index based on the first letter of every word in consideration,
because all we care about is the first and the last letter of every word.
The index is a TStrings where each element is the starting letter and the
corresponding object is a TList with all the indices of the words that
starts with that letter. }
procedure TLastLFirstL.BuildIndex;
var
  i,ii: Integer;
  poke:string;
  st,ed:char;
  List:TList;
  k: Integer;
  found:boolean;
begin
  ClearIndex; //just in case is not the first execution
  if not Assigned(FIndex) then // just in case IS the first execution
    FIndex := TStringList.Create;
  for i := 0 to FPokemons.Count - 1 do begin
    poke := FPokemons[i];
    st := poke[1];
    ed := poke[Length(poke)];
    ii := FIndex.IndexOf(st);
    if ii<0 then //first time we see this starting letter
      ii := FIndex.AddObject(st,TList.Create);
    List := TList(FIndex.Objects[ii]);
    found := false;
    if CheckBox1.Checked then begin //ignore equivalent words (same start, same end)
      //all the List are words with the same start, so lets check the end
      for k := 0 to List.Count - 1 do begin
        poke := FPokemons[integer(List[k])];
        found := poke[Length(poke)] = ed;
        if found then
          break;
      end;
    end;
    if not found then // not checking equivalents, or firts time this end is seen
      List.Add(Pointer(i));
  end;
end;

{ do your thing! }
procedure TLastLFirstL.Button1Click(Sender: TObject);
begin
  Panel1.Caption := 'Calculating..';
  FPokemons.Assign(Memo1.Lines); //words in the game
  BuildIndex;
  BuildChains;
end;

{ frees all the TList used by the index, clears the index }
procedure TLastLFirstL.ClearIndex;
var
  i:integer;
begin
  if not Assigned(FIndex) then
    exit;
  for i := 0 to FIndex.Count - 1 do begin
    TList(FIndex.Objects[i]).Free;
  end;
  FIndex.Clear;
end;

procedure TLastLFirstL.FormCreate(Sender: TObject);
begin
  FPokemons := TStringList.Create;
  FCurrList := TStringList.Create;
end;

procedure TLastLFirstL.FormDestroy(Sender: TObject);
begin
  FCurrList.Free;
  FPokemons.Free;
  ClearIndex; //IMPORTANT!
  FIndex.Free;
end;

{where the magic happens.
Recursive procedure that adds a word to the current list of words.
Receives the starting letter of the word to add, and the "position"
of the word in the chain.
The position is used to ensure a word is not used twice for the list. }
procedure TLastLFirstL.PokeChain(starting: Char;mylevel:integer);
var
  i,ii,plevel:integer;
  List:TList;
  didit:boolean;
begin
  application.processMessages; //don't let the interface die..
  didit := False; //if we can't add another word, then we have reached the maximun length for the list
  ii := FIndex.IndexOf(starting);
  if ii >= 0 then begin //there are words with this starting letter
    List := TList(FIndex.Objects[ii]);
    for i := 0 to List.Count - 1 do begin
      ii := integer(List[i]);
      plevel := integer(FPokemons.Objects[ii]); // if the integer stored in the Object property is lower than mylevel, then this word is already in the list
      if (plevel > mylevel) or (plevel = 0) then begin // you can use the word
        //a try finally would be a good thing here, but...
        FCurrList.Add(FPokemons[ii]); //add the word to the list
        FPokemons.Objects[ii] := Pointer(mylevel); //signal is already in the list
        PokeChain(FPokemons[ii][length(FPokemons[ii])],mylevel+1); //add more words to the list
        FcurrList.Delete(FCurrList.Count-1); //already did my best, lets try with another word
        FPokemons.Objects[ii] := nil; //unsignal it, so it can be used "later"
        didit := True; //we did add one word to the list
      end;
    end;
  end;
  if not didit then //there is no way of making the list longer, process it
    AddCurrList;
end;

end.
