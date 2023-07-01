begin
    comment Gauss-Jordan matrix inversion - 22/01/2021;
    integer n;
    n:=4;
    begin
        procedure rref(m); real array m;
        begin
            integer r, c, i;
            real d, w;
            for r := 1 step 1 until n do begin
                d := m[r,r];
                if d notequal 0 then
                    for c := 1 step 1 until n*2 do
                        m[r,c] := m[r,c] / d
                else
                    outstring(1,"inversion impossible!\n");
                for i := 1 step 1 until n do
                    if i notequal r then begin
                        w := m[i,r];
                        for c := 1 step 1 until n*2 do
                            m[i,c] := m[i,c] - w * m[r,c]
                    end
            end
        end rref;

        procedure inverse(mat,inv); real array mat, inv;
        begin
            integer i, j;
            real array aug[1:n,1:n*2];
            for i := 1 step 1 until n do begin
                for j := 1 step 1 until n do
                    aug[i,j] := mat[i,j];
                for j := 1+n step 1 until n*2 do
                    aug[i,j] := 0;
                aug[i,i+n] := 1
            end;
            rref(aug);
            for i := 1 step 1 until n do
                for j := n+1 step 1 until 2*n do
                    inv[i,j-n] := aug[i,j]
        end inverse;

        procedure show(c, m); string c; real array m;
        begin
            integer i, j;
            outstring(1,"matrix "); outstring(1,c); outstring(1,"\n");
            for i := 1 step 1 until n do begin
                for j := 1 step 1 until n do
                    outreal(1,m[i,j]);
                outstring(1,"\n")
            end
        end show;

        integer i;
        real array a[1:n,1:n], b[1:n,1:n], c[1:n,1:n];
        i:=1; a[i,1]:= 2; a[i,2]:= 1; a[i,3]:= 1; a[i,4]:= 4;
        i:=2; a[i,1]:= 0; a[i,2]:=-1; a[i,3]:= 0; a[i,4]:=-1;
        i:=3; a[i,1]:= 1; a[i,2]:= 0; a[i,3]:=-2; a[i,4]:= 4;
        i:=4; a[i,1]:= 4; a[i,2]:= 1; a[i,3]:= 2; a[i,4]:= 2;
        show("a",a);
        inverse(a,b);
        show("b",b);
        inverse(b,c);
        show("c",c)
    end
end
