begin
    procedure steepestDescent ( long real array x ( * ); long real value alphap, tolerance ) ;
    begin
        long real array fi ( 0 :: 1 );
        long real alpha, g0, g1, delG, b;
        alpha := alphap;
        g0    := g( x ); % Initial estimate of result. %
        % Calculate initial gradient. %
        gradG( fi, x );
        % Calculate initial norm. %
        delG  := 0.0;
        for i := 0 until 1 do delG := delG + ( fi( i ) * fi( i ) );
        delG  := longSqrt( delG );
        b     := alpha / delG;
        % Iterate until value is <= tolerance. %
        while delG > tolerance do begin
            % Calculate next value. %
            for i := 0 until 1 do x(i) := x( i ) - ( b * fi(i) );
            % Calculate next gradient. %
            gradG( fi, x );
            % Calculate next norm. %
            delG  := 0;
            for i := 0 until 1 do delG := delg + ( fi( i ) * fi( i ) );
            delG  := longSqrt( delG );
            if delG > 0 then begin
                b     := alpha / delG;
                % Calculate next value. %
                g1 := g( x );
                % Adjust parameter. %
                if g1 > g0
                then alpha := alpha / 2
                else g0 := g1
            end if_delG_gt_0
        end while_delG_gt_tolerance
    end steepestDescent ;
    % Provides a rough calculation of gradient g(x). %
    procedure gradG ( long real array z, p ( * ) ) ;
    begin
        long real x, y;
        x := p( 0 );
        y := p( 1 );
        z( 0 ) := 2 * ( x - 1 ) * longExp( - ( y * y ) )
                - 4 * x * longExp( -2 * ( x * x ) ) * y * ( y + 2 );
        z( 1 ) := ( -2 * ( x - 1 ) * ( x - 1 ) * y ) * longExp( - y * y )
                + longExp( -2 * x * x ) * ( y + 2 )
                + longExp( -2 * x * x ) * y
    end gradG ;
    % Function for which minimum is to be found. %
    long real procedure g ( long real array x ( * ) ) ;
          ( x( 0 ) - 1 ) * ( x( 0 ) - 1 ) * longExp( - x( 1 ) * x( 1 ) )
        + x( 1 ) * ( x( 1 ) + 2 ) * longExp( - 2 * x( 0 ) * x( 0 ) )
        ;
    begin
        long real alpha, tolerance;
        long real array x ( 0 :: 1 );
        x( 0 ) :=  0.1; % Initial guess of location of minimum. %
        x( 1 ) := -1;
        tolerance := 0.0000006;
        alpha     := 0.1;
        steepestDescent( x, alpha, tolerance );
        r_format := "A"; r_w := 11; r_d := 7; s_w := 0; % output formatting %
        write( "Testing steepest descent method:" );
        write( "The minimum is at x(0) = ", x( 0 ), ", x(1) = ", x( 1 ) )
    end
end.
