% performs bitwise and, or, not, left-shift and right shift on the integers n1 and n2 %
% Algol W does not have xor, arithmetic right shift, left rotate or right rotate      %
procedure bitOperations ( integer value n1, n2 ) ;
begin
    bits b1, b2;
    % the Algol W bitwse operations operate on bits values, so we first convert the   %
    % integers to bits values using the builtin bitstring procedure                   %
    % the results are converted back to integers using the builtin number procedure   %
    % all Algol W bits and integers are 32 bits quantities                            %
    b1 := bitstring( n1 );
    b2 := bitstring( n2 );
    % perform the operaations and display the results as integers                     %
    write( n1, " and ", n2, " = ", number( b1 and b2 ) );
    write( n1, " or  ", n2, " = ", number( b1 or  b2 ) );
    write( "                "
         ,     " not ", n1, " = ", number(    not b1 ) );
    write( n1, " shl ", n2, " = ", number( b1 shl n2 ), " (  left-shift )"  );
    write( n1, " shr ", n2, " = ", number( b1 shr n2 ), " ( right-shift )"  )
end bitOPerations ;
