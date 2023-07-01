    program disjointsort;

    procedure swap(var a, b: Integer);
    var
    temp: Integer;
    begin
    temp := a;
    a := b;
    b := temp;
    end;

    procedure d_sort(var index,arr:array of integer);
    var
    n,i,j,num:integer;
    begin
    num:=length(index);
    for n:=1 to 2 do
    begin
    for i:=0 to num-1 do
    begin
    for j:=i+1 to num-1 do
    begin
     if n=1 then if index[j]<index[i] then swap(index[j],index[i]);
     if n=2 then if arr[index[j]]<arr[index[i]] then swap(arr[index[j]],arr[index[i]]);
    end;
    end;
    end;
    end;

    var
    i:integer;
    arr  :array[0 .. 7] of integer =(7, 6, 5, 4, 3, 2, 1, 0);
    index:array[0 .. 2] of integer =(6, 1, 7);


    begin
    writeln('Before');
    for i:=0 to 7 do write(arr[i],'  ');
    writeln;
    d_sort(index,arr);
    writeln('After');
    for i:=0 to 7 do write(arr[i],'  ');
    writeln;
    readln;
    end.
