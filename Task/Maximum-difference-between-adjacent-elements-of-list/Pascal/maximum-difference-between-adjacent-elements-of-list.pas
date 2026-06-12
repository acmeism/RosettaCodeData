program maximumDifferenceBetweenAdjacentElementsOfList(output);

function internalDistance(
		list: array[indexMinimum..indexMaximum: integer] of real
	): real;
var
	i: integer;
	maximumDistance, currentDistance: real;
begin
	maximumDistance := 0.0;
	
	for i := indexMinimum to pred(indexMaximum) do
	begin
		currentDistance := abs(list[i] - list[succ(i)]);
		
		if currentDistance > maximumDistance then
		begin
			maximumDistance := currentDistance
		end
	end;
	
	internalDistance := maximumDistance
end;

var
	list: array[1..2] of real;
begin
	list[1] := 1.0; list[2] := 8.0;
	writeLn(internalDistance(list));
end.
