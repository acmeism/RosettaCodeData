begin
    comment Sorting algorithms/Bubble sort - Algol 60;
    integer nA;
    nA:=20;

    begin
        integer array A[1:20];

        procedure bubblesort(lb,ub);
        value lb,ub; integer lb,ub;
        begin
            integer i;
            boolean swapped;
            swapped :=true;
            for i:=1 while swapped do begin
                swapped:=false;
                for i:=lb step  1 until ub-1 do if A[i]>A[i+1] then begin
                    integer temp;
                    temp  :=A[i];
                    A[i]  :=A[i+1];
                    A[i+1]:=temp;
                    swapped:=true
                end
            end
        end bubblesort;

        procedure inittable(lb,ub);
        value lb,ub; integer lb,ub;
        begin
            integer i;
            for i:=lb step 1 until ub do A[i]:=entier(rand*100)
        end inittable;

        procedure writetable(lb,ub);
        value lb,ub; integer lb,ub;
        begin
            integer i;
            for i:=lb step 1 until ub do outinteger(1,A[i]);
            outstring(1,"\n")
        end writetable;


        inittable(1,nA);
        writetable(1,nA);
        bubblesort(1,nA);
        writetable(1,nA)
    end
end
