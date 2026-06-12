program sattoloCycle(output);

var
	i: integer;
	sample1: array[0..0] of integer;
	sample2: array[0..1] of integer;
	sample3: array[0..2] of integer;
	sample4: array[0..11] of integer;

procedure shuffle(var item: array[itemMinimum..itemMaximum: integer] of integer);
var
	i, randomIndex, temporaryValue: integer;
begin
	for i := itemMaximum downto succ(itemMinimum) do
	begin
		randomIndex := random(i - itemMinimum) + itemMinimum;
		temporaryValue := item[randomIndex];
		item[randomIndex] := item[i];
		item[i] := temporaryValue
	end
end;

procedure printArray(var item: array[itemMinimum..itemMaximum: integer] of integer);
var
	i: integer;
begin
	for i := itemMinimum to itemMaximum do
	begin
		write(item[i]:5)
	end;
	writeLn
end;

begin
	sample1[0] := 10;
	sample2[0] := 10; sample2[1] := 20;
	sample3[0] := 10; sample3[1] := 20; sample3[2] := 30;
	sample4[0] := 11; sample4[1] := 12; sample4[2] := 13; sample4[3] := 14;
	sample4[4] := 15; sample4[5] := 16; sample4[6] := 17; sample4[7] := 18;
	sample4[8] := 19; sample4[9] := 20; sample4[10] := 21; sample4[11] := 22;
	
	shuffle(sample1); printArray(sample1);
	shuffle(sample2); printArray(sample2);
	shuffle(sample3); printArray(sample3);
	shuffle(sample4); printArray(sample4);
end.
