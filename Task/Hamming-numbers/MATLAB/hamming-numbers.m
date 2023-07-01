n = 40;

powers_2 = 2.^[0:n-1];
powers_3 = 3.^[0:n-1];
powers_5 = 5.^[0:n-1];

matrix = powers_2' * powers_3;
powers_23 = sort(reshape(matrix,n*n,1));


matrix = powers_23 * powers_5;
powers_235 = sort(reshape(matrix,n*n*n,1));

%
% Remove the integer overflow values.
%
powers_235 = powers_235(powers_235 > 0);

disp(powers_235(1:20))
disp(powers_235(1691))
