NDoors := proc( N :: posint )
        # Initialise, using 0 to represent "closed"
        local pass, door, doors := Array( 1 .. N, 'datatype' = 'integer'[ 1 ] );
        # Now do N passes
        for pass from 1 to N do
                for door from pass by pass while door <= N do
                        doors[ door ] := 1 - doors[ door ]
                end do
        end do;
        # Output
        for door from 1 to N do
                printf( "Door %d is %s.\n", door, `if`( doors[ door ] = 0, "closed", "open" ) )
        end do;
        # Since this is a printing routine, return nothing.
        NULL
end proc:
