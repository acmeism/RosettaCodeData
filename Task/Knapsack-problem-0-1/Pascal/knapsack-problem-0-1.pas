program project1;
uses
  sysutils, classes, math;

const
  MaxWeight = 400;
  N = 22;

type
  TMaxArray = array[0..N, 0..MaxWeight] of integer;

  TEquipment = record
    Description : string;
    Weight : integer;
    Value : integer;
  end;

  TEquipmentList = array[1..N] of TEquipment;

var
   M:TMaxArray;
   MaxValue, WeightLeft, i, j : integer;
   S,KnapSack:TStringList;
   L:string;
   List:TEquipmentList;

begin
   //Put all the items into an array called List
   L:=
     'map ,9,150,compass,13,35,water,153,200,sandwich,50,160,glucose,15,60,tin,68,45,banana,27,60,apple,39,40,' +
     'cheese,23,30,beer,52,10,suntancreme,11,70,camera,32,30,T-shirt,24,15,trousers,48,40,umbrella,73,40,' +
     'waterprooftrousers,42,70,waterproofoverclothes,43,75,notecase,22,80,sunglasses,7,20,towel,18,12,' +
     'socks,4,50,book,30,10';
   S:=TStringList.create;
   S.Commatext:=L;

   For i:= 1 to N do
   begin
      List[i].Description:=S[3*i - 3];
      List[i].Weight:=strtoint(S[3*i - 2]);
      List[i].Value:=strtoint(S[3*i - 1]);
   end;

   //create M, a table linking the possible items for each weight
   //and recording the value at that point
   for j := 0 to MaxWeight do
       M[0, j] := 0;

   for i := 1 to N do
       for j := 0 to MaxWeight do
           if List[i].weight > j then
               M[i, j] := M[i-1, j]
           else
               M[i, j] := max(M[i-1, j], M[i-1, j-List[i].weight] + List[i].value);

   //get the highest total value by testing every value in table M
   MaxValue := 0;
   for i:=1 to N do
       for j:= 0 to MaxWeight do
           If M[i,j] > MaxValue then
               MaxValue := m[i,j];

   writeln('Highest total value : ',MaxValue);

  //Work backwards through the items to find those items that go in the Knapsack (a stringlist)
   KnapSack := TStringList.create;
   WeightLeft := MaxWeight;
   For i:= N downto 1 do
       if M[i,WeightLeft] = MaxValue then
          if M[i-1, WeightLeft - List[i].Weight] = MaxValue - List[i].Value then
          begin
            Knapsack.add(List[i].Description + ' ' + IntToStr(List[i].Weight)+ ' ' + inttostr(List[i].Value));
            MaxValue := MaxValue - List[i].Value;
            WeightLeft := WeightLeft - List[i].Weight;
          end;

   //Show the items in the knapsack
   writeln('Number of items     : ',KnapSack.count);
   writeln('-------------------------');
   For i:= KnapSack.count-1 downto 0 do
     writeln(KnapSack[i]);

   KnapSack.free;
   S.free;
   writeln('-------------------------');
   writeln('done');
   readln;
end.
