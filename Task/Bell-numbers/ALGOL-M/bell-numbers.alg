begin
integer function index(row, col);
integer row, col;
index := row * (row-1)/ 2 + col;

integer ROWS; ROWS := 15;
begin
    decimal(11) array bell[0:ROWS*(ROWS+1)/2];
    integer i, j;

    bell[index(1, 0)] := 1.;
    for i := 2 step 1 until ROWS do
    begin
        bell[index(i, 0)] := bell[index(i-1, i-2)];
        for j := 1 step 1 until i-1 do
            bell[index(i,j)] := bell[index(i,j-1)] + bell[index(i-1,j-1)];
    end;

    write("First fifteen Bell numbers:");
    for i := 1 step 1 until ROWS do
    begin
        write(i);
        writeon(": ");
        writeon(bell[index(i,0)]);
    end;

    write("");
    write("First ten rows of Bell's triangle:");
    for i := 1 step 1 until 10 do
    begin
        write("");
        for j := 0 step 1 until i-1 do
            writeon(bell[index(i,j)]);
    end;
end;
end
