program BDS;
const MAX = 1000;
type
    type_matrix = record
	lin,col:integer;
	matrix: array [1..MAX,1..MAX] of boolean;
    end;

    type_vector = record
	size:integer;
	vector: array[1..MAX] of integer;
    end;

procedure BeadSort(var v:type_vector);
var
    i,j,k,sum:integer;
    m:type_matrix;
begin
    m.lin:=v.size;

    (* the number of columns is equal to the greatest element *)
    m.col:=0;
    for i:=1 to v.size do
	if v.vector[i] > m.col then
	    m.col:=v.vector[i];

    (* initializing the matrix *)
    for j:=1 to m.lin do
	begin
	    k:=1;
	    for i:=m.col downto 1 do
		begin
		    if v.vector[j] >= k then
			m.matrix[i,j]:=TRUE
		    else
			m.matrix[i,j]:=FALSE;
		    k:=k+1;
		end;
	end;

    (* Sort the matrix *)
    for i:=1 to m.col do
	begin
	    (* Count the beads and set the line equal FALSE *)
	    sum:=0;
	    for j:=1 to m.lin do
		begin
		    if m.matrix[i,j] then
			sum:=sum+1;
		    m.matrix[i,j]:=FALSE;
		end;

	    (* The line receives the bead sorted *)
	    for j:=m.lin downto m.lin-sum+1 do
		m.matrix[i,j]:=TRUE;
	end;

    (* Convert the sorted bead matrix to a sorted vector *)
    for j:=1 to m.lin do
	begin
	    v.vector[j]:=0;
	    i:=m.col;
	    while (m.matrix[i,j] = TRUE)and(i>=1) do
		begin
		    v.vector[j]+=1;
		    i:=i-1;
		end;
	end;
end;

procedure print_vector(var v:type_vector);
var i:integer;
begin
    for i:=1 to v.size do
	write(v.vector[i],' ');
    writeln;
end;

var
    i:integer;
    v:type_vector;
begin
    writeln('How many numbers do you want to sort?');
    readln(v.size);
    writeln('Write the numbers:');

    for i:=1 to v.size do
	read(v.vector[i]);

    writeln('Before sort:');
    print_vector(v);

    BeadSort(v);

    writeln('After sort:');
    print_vector(v);
end.
