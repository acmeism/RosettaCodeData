function table = timesTable(N)

    %Generates a column vector with integers from 1 to N
    rowLabels = (1:N)';

    %Generate a row vector with integers from 0 to N
    columnLabels = (0:N);

    %Generate the multiplication table using the kronecker tensor product
    %of two vectors one a column vector and the other a row vector
    table = kron((1:N),(1:N)');

    %Make it upper triangular and concatenate the rowLabels and
    %columnLabels to the table
    table = [columnLabels; rowLabels triu(table)];

end
