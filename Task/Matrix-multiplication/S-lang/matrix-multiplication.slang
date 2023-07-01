% Matrix multiplication is a built-in with the S-Lang octothorpe operator.
variable A = [1,2,3,4,5,6];
reshape(A, [2,3]);             % reshape 1d array to 2 rows, 3 columns
printf("A is %S\n", A); print(A);

variable B = [1:6];            % index range, 1 to 6 same as above in A
reshape(B, [3,2]);             % reshape to 3 rows, 2 columns
printf("\nB is %S\n", B); print(B);

printf("\nA # B is %S\n", A#B);
print(A#B);

% Multiply binary operator is different, dimensions need to be equal
reshape(B, [2,3]);
printf("\nA * B is %S (with reshaped B to match A)\n", A*B);
print(A*B);
