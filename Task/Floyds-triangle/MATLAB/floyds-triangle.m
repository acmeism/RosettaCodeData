function floyds_triangle(n)

width = 1+floor(log10(nr*(nr+1)/2));
for k=1:n,
	fprintf(stdout,' %*i',[width(ones(1,k));k*(k-1)/2+1:k*(k+1)/2]);
        fprintf(stdout,'\n');
end;
