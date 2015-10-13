begin
    % Algol W only supplies sin, cos and arctan as standard. We can define    %
    % arcsin, arccos and tan functions using these. The standard functions    %
    % use radians so we also provide versions that use degrees                %

    % convert degrees to radians   %
    real procedure toRadians( real value x ) ; pi * ( x / 180 );
    % convert radians to degrees   %
    real procedure toDegrees( real value x ) ; 180 * ( x / pi );
    % tan of an angle in radians   %
    real procedure tan( real value x ) ; sin( x ) / cos( x );
    % arcsin in radians            %
    real procedure arcsin( real value x ) ; arctan( x / sqrt( 1 - ( x * x ) ) );
    % arccos in radians            %
    real procedure arccos( real value x ) ; arctan( sqrt( 1 - ( x * x ) ) / x );
    % sin of an angle in degrees   %
    real procedure sinD( real value x ) ; sin( toRadians( x ) );
    % cos of an angle in degrees   %
    real procedure cosD( real value x ) ; cos( toRadians( x ) );
    % tan of an angle in degrees   %
    real procedure tanD( real value x ) ; tan( toRadians( x ) );
    % arctan in degrees            %
    real procedure arctanD( real value x ) ; toDegrees( arctan( x ) );
    % arcsin in degrees            %
    real procedure arcsinD( real value x ) ; toDegrees( arcsin( x ) );
    % arccos in degrees            %
    real procedure arccosD( real value x ) ; toDegrees( arccos( x ) );


    % test the procedures %
    begin

        real piOver4, piOver3, oneOverRoot2, root3Over2;
        piOver3 := pi / 3; piOver4  := pi / 4;
        oneOverRoot2 := 1.0 / sqrt( 2 ); root3Over2 := sqrt( 3 ) / 2;


        r_w := 12; r_d := 5; r_format := "A"; s_w := 0; % set output format   %

        write( "PI/4: ", piOver4, " 1/root(2): ", oneOverRoot2 );
        write();
        write( "sin 45 degrees: ", sinD( 45 ), " sin pi/4 radians: ", sin( piOver4 ) );
        write( "cos 45 degrees: ", cosD( 45 ), " cos pi/4 radians: ", cos( piOver4 ) );
        write( "tan 45 degrees: ", tanD( 45 ), " tan pi/4 radians: ", tan( piOver4 ) );
        write();
        write( "arcsin( sin( pi/4 radians ) ): ", arcsin( sin( piOver4 ) ) );
        write( "arccos( cos( pi/4 radians ) ): ", arccos( cos( piOver4 ) ) );
        write( "arctan( tan( pi/4 radians ) ): ", arctan( tan( piOver4 ) ) );
        write();
        write( "PI/3: ", piOver4, " root(3)/2: ", root3Over2 );
        write();
        write( "sin 60 degrees: ", sinD( 60 ), " sin pi/3 radians: ", sin( piOver3 ) );
        write( "cos 60 degrees: ", cosD( 60 ), " cos pi/3 radians: ", cos( piOver3 ) );
        write( "tan 60 degrees: ", tanD( 60 ), " tan pi/3 radians: ", tan( piOver3 ) );
        write();
        write( "arcsin( sin( 60 degrees ) ): ", arcsinD( sinD( 60 ) ) );
        write( "arccos( cos( 60 degrees ) ): ", arccosD( cosD( 60 ) ) );
        write( "arctan( tan( 60 degrees ) ): ", arctanD( tanD( 60 ) ) );

    end

end.
