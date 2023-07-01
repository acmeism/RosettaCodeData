begin
    % returns the multifactorial of n with the specified degree %
    integer procedure multifactorial ( integer value n, degree ) ;
        begin
            integer mf, v;
            mf := v := n;
            while begin
                      v := v - degree;
                      v > 1
            end do mf := mf * v;
            mf
        end multifactorial ;

    % tests as per task %
    for degree := 1 until 5 do begin
        i_w := 1; s_w := 0; % output formatting %
        write( "Degree: ", degree, ":" );
        for v := 1 until 10 do begin
            writeon( " ", multifactorial( v, degree ) )
        end for_v
    end for_degree
end.
