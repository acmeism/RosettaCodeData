% declare a procedure that has a three-dimensional array parameter       %
procedure p ( integer array a1 ( *, *, * ) ) ; a1( 1, 2, 1 ) := 3 ;

% call the procedure with a subset of the 4 dimensional array            %
p( a( *, 2, *, * ) );
