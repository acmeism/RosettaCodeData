function table = timesTable(N)
    table = [(0:N); (1:N)' triu( kron((1:N),(1:N)') )];
end
