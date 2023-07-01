{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,Regvar,ASMCSE,CSE,PEEPHOLE}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils; //for timing
type
  tDataElem  =  record
                  myText : AnsiString;
                  myX,
                  myY : double;
                  myTag,
                  myOrgIdx : LongInt;
                end;

  tpDataElem = ^tDataElem;
  tData = array of tDataElem;

  tSortData = array of tpDataElem;
  tCompFunc = function(A,B:tpDataElem):integer;
var
  Data    : tData;
  Sortdata,
  tmpData : tSortData;

procedure InitData(var D:tData;cnt: LongWord);
var
  i,k: LongInt;
begin
  Setlength(D,cnt);
  Setlength(SortData,cnt);
  Setlength(tmpData,cnt shr 1 +1 );
  k := 10*cnt;
  For i := cnt-1 downto 0 do
  Begin
    Sortdata[i] := @D[i];
    with D[i] do
    Begin
      myText := Format('_%.9d',[random(cnt)+1]);
      myX := Random*k;
      myY := Random*k;
      myTag := Random(k);
      myOrgIdx := i;
    end;
  end;
end;

procedure FreeData(var D:tData);
begin
  Setlength(tmpData,0);
  Setlength(SortData,0);
  Setlength(D,0);
end;

function CompLowercase(A,B:tpDataElem):integer;
var
  lcA,lcB: String;
Begin
  lcA := lowercase(A^.myText);
  lcB := lowercase(B^.myText);
  result := ORD(lcA > lcB)-ORD(lcA < lcB);
end;

function myCompText(A,B:tpDataElem):integer;
{sort an array (or list) of strings in order of descending length,
  and in ascending lexicographic order for strings of equal length.}
var
  lA,lB:integer;

Begin
  lA := Length(A^.myText);
  lB := Length(B^.myText);
  result := ORD(lA<lB)-ORD(lA>lB);
  IF result = 0 then
    result := CompLowercase(A,B);
end;

function myCompX(A,B:tpDataElem):integer;
//same as sign without jumps in assembler code
begin
  result := ORD(A^.myX > B^.myX)-ORD(A^.myX < B^.myX);
end;

function myCompY(A,B:tpDataElem):integer;
Begin
  result := ORD(A^.myY > B^.myY)-ORD(A^.myY < B^.myY);
end;

function myCompTag(A,B:tpDataElem):integer;
Begin
  result := ORD(A^.myTag > B^.myTag)-ORD(A^.myTag < B^.myTag);
end;

procedure InsertionSort(left,right:integer;var a: tSortData;CompFunc: tCompFunc);
var
   Pivot : tpDataElem;
   i,j  : LongInt;
begin
 for i:=left+1 to right do
 begin
   j :=i;
   Pivot := A[j];
   while (j>left) AND (CompFunc(A[j-1],Pivot)>0) do
   begin
     A[j] := A[j-1];
     dec(j);
   end;
   A[j] :=PiVot;// s.o.
 end;
end;


procedure mergesort(left,right:integer;var a: tSortData;CompFunc: tCompFunc);
var
  i,j,k,mid :integer;
begin
{// without insertion sort
  If right>left then
}
//{ test insertion sort
  If right-left<=14 then
     InsertionSort(left,right,a,CompFunc)
  else
//}
  begin
    //recursion
    mid := (right+left) div 2;
    mergesort(left, mid,a,CompFunc);
    mergesort(mid+1, right,a,CompFunc);
    //already sorted ?
    IF CompFunc(A[Mid],A[Mid+1])<0 then
      exit;

    //##########  Merge  ##########
    //copy lower half to temporary array
    move(A[left],tmpData[0],(mid-left+1)*SizeOf(Pointer));
    i := 0;
    j := mid+1;
    k := left;
    // re-integrate
    while (k<j) AND (j<=right) do
      begin
      IF CompFunc(tmpData[i],A[j])<=0 then
        begin
        A[k] := tmpData[i];
        inc(i);
        end
      else
        begin
        A[k]:= A[j];
        inc(j);
        end;
      inc(k);
      end;
    //the rest of tmpdata a move should do too, in next life
    while (k<j) do
      begin
      A[k] := tmpData[i];
      inc(i);
      inc(k);
      end;
  end;
end;

var
  T1,T0: TDateTime;
  i : integer;
Begin
  randomize;
  InitData(Data,1*1000*1000);

  T0 := Time;
  mergesort(Low(SortData),High(SortData),SortData,@myCompText);
  T1 := Time;
  Writeln('myText ',FormatDateTime('NN:SS.ZZZ',T1-T0));
//  For i := 0 to High(Data) do  Write(SortData[i].myText);  writeln;
  T0 := Time;
  mergesort(Low(SortData),High(SortData),SortData,@myCompX);
  T1 := Time;
  Writeln('myX    ',FormatDateTime('NN:SS.ZZZ',T1-T0));
 //check
  For i := 1 to High(Data) do
    IF myCompX(SortData[i-1],SortData[i]) = 1 then
      Write(i:8);

  T0 := Time;
  mergesort(Low(SortData),High(SortData),SortData,@myCompY);
  T1 := Time;
  Writeln('myY    ',FormatDateTime('NN:SS.ZZZ',T1-T0));

  T0 := Time;
  mergesort(Low(SortData),High(SortData),SortData,@myCompTag);
  T1 := Time;
  Writeln('myTag  ',FormatDateTime('NN:SS.ZZZ',T1-T0));

  FreeData (Data);
end.
