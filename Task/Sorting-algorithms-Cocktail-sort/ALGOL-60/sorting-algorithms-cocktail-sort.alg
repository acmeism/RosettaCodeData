begin
    comment Sorting algorithms/Cocktail sort - Algol 60;
    integer nA;
    nA:=20;

    begin
        integer array A[1:nA];

        procedure cocktailsort(lb,ub);
        value lb,ub; integer lb,ub;
        begin
            integer i,lbx,ubx;
            boolean swapped;
            lbx:=lb; ubx:=ub-1; swapped :=true;
            for i:=1 while swapped do begin

                procedure swap(i); value i; integer i;
                begin
                    integer temp;
                    temp  :=A[i];
                    A[i]  :=A[i+1];
                    A[i+1]:=temp;
                    swapped:=true
                end swap;

                swapped:=false;
                    for i:=lbx step  1 until ubx do if A[i]>A[i+1] then swap(i);
                if swapped
                then begin
                    for i:=ubx step -1 until lbx do if A[i]>A[i+1] then swap(i);
                    ubx:=ubx-1; lbx:=lbx+1
                end
            end
        end cocktailsort;

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

        nA:=20;
        inittable(1,nA);
        writetable(1,nA);
        cocktailsort(1,nA);
        writetable(1,nA)
    end
end
