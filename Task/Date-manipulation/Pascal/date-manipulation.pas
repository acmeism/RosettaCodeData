PROGRAM Date_manipulation;

    {$IFDEF FPC}
        {$mode objfpc}                         (*) directive TO be used for defining classes       (*)
        {$m+}                                  (*) directive TO be used for using constructor      (*)

        {$LONGSTRINGS ON}                      (*) aka {H+}    = ansistring                        (*)
        {$RANGECHECKS ON}                      (*) aka {$R+}                                       (*)
        {$S+}                                  (*) Stack checking (REQUIRED for exceptions)        (*)
        {$TYPEDADDRESS ON}                     (*) aka {$T+}                                       (*)
        {$modeswitch exceptions}               (*) Explicitly enable exceptions                    (*)
        {$modeswitch advancedrecords}
    {$ELSE}
        {$APPTYPE CONSOLE}
    {$ENDIF}

    {$MACRO ON}
        {$DEFINE nl         := #13#10 }
        {$DEFINE tab        := #9         }

    {$WARNINGS OFF W1033}     (*)  Stop `data loss from "UnicodeString" to "AnsiString"` messages  (*)
    {$WARN 6058 OFF}          (*)  Disable `not inlined` messages                                  (*)

    USES
        SysUtils,
        DateUtils,
        StrUtils,
        TZDB;

(*)
            This program uses the tzdb unit by Alexandru Ciobanu.
            Copyright (c) 2010-2020, Alexandru Ciobanu (alex+git@ciobanu.org)
            All rights reserved.
            This software is provided "as is" without any express or implied warranties.
            Please refer to the license for usage terms.

(*)


        FUNCTION ParseDateTime(CONST DateTimeStr: string; out TimeZone: string): TDateTime;

            VAR
                Parts   :          TStringArray ;
                LMonths :       TMonthNameArray ;
                M, D, Y :               Integer ;
                TimePart:                string ;

            BEGIN

                Parts     := DateTimeStr.Split( [ ' ' ] )            ;

                IF Length(Parts) <> 5 THEN
                    raise Exception.Create( 'Invalid date format' )  ;

                (*)     Extract Month using system long Month names                             (*)
                LMonths := DefaultFormatSettings.LongMonthNames      ;
                M             := 1 + IndexStr( Parts[ 0 ], LMonths ) ;
                D             :=     StrToInt( Parts[ 1 ] )          ;
                Y             :=     StrToInt( Parts[ 2 ] )          ;

                (*)     Handle time with possible space between time and AM/PM              (*)
                TimePart := Parts[3];
                IF Pos('m', Parts[3]) = 0 THEN          (*) If 'm' not found, combine parts (*)
                    TimePart := Parts[3] + Parts[4];

                TimeZone    := Parts[High(Parts)];      (*) Get timezone abbreviation       (*)

                Result      :=  EncodeDateTime  ( Y, M, D,
                                HourOf          ( StrToTime( TimePart ) ),
                                MinuteOf        ( StrToTime( TimePart ) ), 0, 0 ) ;
            END;

    CONST
        DATESTR =     'mmmm d yyyy h:nnam/pm' ;

    VAR
        OriginalDate:               string;
        LocalTime, UTC, NewTime: TDateTime;
        NY_TZ, SYD_TZ:    TBundledTimeZone;
        NY_Abbrev, SYD_Abbrev:      string;

    BEGIN

        OriginalDate := 'March 7 2009 7:30pm EST';

        LocalTime     := ParseDateTime( OriginalDate, NY_Abbrev ) ;

        (*) Initialize timezones    (*)
        NY_TZ       := TBundledTimeZone.GetTimeZone( 'America/New_York' ) ;
        SYD_TZ      := TBundledTimeZone.GetTimeZone( 'Australia/Sydney' ) ;
        UTC         := NY_TZ.ToUniversalTime( LocalTime ) ; (*) Convert to UTC                          (*)
        UTC         := IncHour( UTC, 12 ) ;                 (*) Add 12 hours in UTC                     (*)

        NewTime     := NY_TZ.ToLocalTime( UTC )     ;       (*) back to local time with DST adjustment  (*)
        NY_Abbrev   := NY_TZ.GetAbbreviation( UTC ) ;

        (*) Convert TO Sydney time  (*)
        SYD_Abbrev := SYD_TZ.GetAbbreviation( SYD_TZ.ToLocalTime( UTC ) ) ;

        (*) Output results          (*)

        WriteLn('Original time: ', FormatDateTime( DATESTR, LocalTime ), ' EST' ) ;
        WriteLn('+12 hours:     ', FormatDateTime( DATESTR, NewTime ), ' ', NY_Abbrev ) ;
        WriteLn('Sydney time:   ', FormatDateTime( DATESTR, SYD_TZ.ToLocalTime( UTC ) ), ' ', SYD_Abbrev ) ;

    END. (*) Of PROGRAM Date_manipulation.pas (*)

(*)
