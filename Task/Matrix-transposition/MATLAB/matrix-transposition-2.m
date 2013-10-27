B=size(A);   %In this code, we assume that a previous matrix "A" has already been inputted.
for j=1:B(1)
    for i=1:B(2)
        C(i,j)=A(j,i);
    end      %The transposed A-matrix should be C
end
