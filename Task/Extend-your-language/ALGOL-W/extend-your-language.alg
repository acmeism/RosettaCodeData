begin
    % executes pBoth, p1, p2 or pNeither                                      %
    %     depending on whether c1 and c2 are true, c1 is true, c2 is true     %
    %                          neither c1 nor c2 are true                     %
    procedure if2 ( logical value c1, c2
                  ; procedure     pBoth, p1, p2, pNeither
                  );
        if      c1 and c2 then pBoth
        else if c1        then p1
        else if        c2 then p2
        else                   pNeither
        ;
    begin
        logical a, b;
        a := true;
        b := false;
        if2( a, b
           , write( "both:    a and b are TRUE"  )
           , write( "first:   only a is TRUE"    )
           , write( "second:  only b is TRUE"    )
           , write( "neither: a and b are FALSE" )
           )
    end
end.
