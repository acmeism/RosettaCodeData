begin
    % record structure to hold a compound duration %
    record Duration ( integer weeks, days, hours, minutes, seconds );

    % returns seconds converted to a Duration %
    reference(Duration) procedure toDuration( integer value secs ) ;
    begin
        integer  time;
        reference(Duration) d;
        time := secs;
        d    := Duration( 0, 0, 0, 0, 0 );
        seconds(d) := time rem 60;
        time       := time div 60;
        minutes(d) := time rem 60;
        time       := time div 60;
        hours(d)   := time rem 24;
        time       := time div 24;
        days(d)    := time rem  7;
        time       := time div  7;
        weeks(d)   := time;
        d
    end toDuration ;

    % returns a readable form of the DURATION %
    string(80) procedure durationToString ( reference(Duration) value d ) ;
    begin
        % appends an element of the compound duration to text %
        procedure add ( integer   value componentValue
                      ; string(6) value componentName
                      ; integer   value nameLength
                      ) ;
        begin
            string(9) vStr;
            integer   v, vPos;
            if needSeparator then begin
                % must separate this component from the previous %
                text( textPos // 2 ) := ", ";
                textPos:= textPos + 2
             end if_needSepartator ;
             % add the value %
             % construct a string representaton of the value with the digits reversed %
             % as this routine isn't called if componentValue is 0 or -ve, we don't need to handle %
             % the componentVaue <= 0 case %
             v    := componentValue;
             vStr := "";
             vPos := 0;
             while v > 0 do begin
                 vStr( vPos // 1 ) := code( decode( "0" ) + ( v rem 10 ) );
                 vPos              := vPos + 1;
                 v                 := v div 10
             end while_v_gt_0 ;
             % add the digits in the correct order %
             while vPos > 0 do begin
                 vPos                 := vPos - 1;
                 text( textPos // 1 ) := vStr( vPos // 1 );
                 textPos              := textPos + 1
             end while_vPos_gt_0 ;
             % add the component name %
             text( textPos // 6 ) := componentName;
             textPos := textPos + nameLength;
             % if there is another component, we'll need a separator %
             needSeparator := true
        end add ;

        string(80) text;
        logical    needSeparator;
        integer    textPos;
        textPos       := 0;
        text          := "";
        needSeparator := false;
        if   weeks(d) not = 0 then add(   weeks(d), " wk",  3 );
        if    days(d) not = 0 then add(    days(d), " d",   2 );
        if   hours(d) not = 0 then add(   hours(d), " hr",  3 );
        if minutes(d) not = 0 then add( minutes(d), " min", 4 );
        if seconds(d) not = 0 then add( seconds(d), " sec", 4 );
        if text = "" then begin
            % duration is 0 %
            text := "0 sec"
        end if_text_is_blank ;
        text
   end % durationToString % ;

    % test cases %
    write( durationToString( toDuration(    7259 ) ) );
    write( durationToString( toDuration(   86400 ) ) );
    write( durationToString( toDuration( 6000000 ) ) )
end.
