/* Rexx */
  sampleDate = 'March 7 2009 7:30pm EST'

  Parse value sampleDate with tm td ty tt tz .
  Parse value time('l', tt, 'c') with hh ':' mm ':' ss '.' us .

  timezones. = ''
  Call initTimezones
  mn = monthNameToNumber(tm)
  zuluOffset = getTZOffset(tz)

  Drop !TZ !MSG
  day.1.!TZ = zuluOffset
  day.1.!MSG = 'Original date:'
  day.1 = .DateTime~new(ty, mn, td, hh, mm, ss, us, day.1.!TZ * 60)
  day.2.!TZ = zuluOffset
  day.2.!MSG = 'Result after adding 12 hours to date:'
  day.2 = day.1~addHours(12)
  day.3.!TZ = getTZOffset('UTC') -- AKA GMT == Greenwich Mean Time
  day.3.!MSG = 'Result shifted to "UTC (Zulu)" time zone:'
  day.3 = day.1~toTimeZone(day.3.!TZ)
  day.4.!TZ = getTZOffset('PST') -- Pacific Standard Time
  day.4.!MSG = 'Result shifted to "Pacific Standard Time" time zone:'
  day.4 = day.2~toTimeZone(day.4.!TZ * 60)
  day.5.!TZ = getTZOffset('NPT') -- Nepal Time
  day.5.!MSG = 'Result shifted to "Nepal Time" time zone:'
  day.5 = day.2~toTimeZone(day.5.!TZ * 60)
  day.0 = 5

  Say 'Manipulate the date string "'sampleDate'" and present results in ISO 8601 timestamp format:'
  Say
  Loop d_ = 1 to day.0
    Say day.d_.!MSG
    Say day.d_~isoDate || getUTCOffset(day.d_.!TZ, 'z')
    Say
    End d_

Return 0

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
isTrue: Procedure; Return (1 == 1)

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
isFalse: Procedure; Return \isTrue()

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
monthNameToNumber:
Procedure
Do
  Parse arg tm .

  mnamesList = 'January February March April May June July August September October November December'

  Loop mn = 1 to mnamesList~words
    mnx = mnamesList~word(mn)
    If mnx~upper~abbrev(tm~upper, 3) then Do
      Leave mn
      End
    End mn

  Return mn
End
Exit

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getTZOffset:
Procedure expose timezones.
Do
  Parse upper arg tz .
  Drop !REGION !FULLNAME !OFFSET !ZNAMEALT

  offset = 0
  Loop z_ = 1 to timezones.0
    If tz = timezones.z_ then Do
      offset = timezones.z_.!OFFSET
      Leave z_
      End
    End z_

  Return offset;
End
Exit

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
getUTCOffset:
Procedure expose timezones.
Do
  Parse arg oh ., zulu .

  oha = abs(oh)
  If oha = 0 & 'ZULU'~abbrev(zulu~upper, 1) then Do
    offset = 'Z'
    End
  else Do
    If oh < 0 then ew = '-'
              else ew = '+'
    om = oha * 60
    oom = om // 60 % 1
    ooh = om % 60
    offset = ew || ooh~right(2, 0) || oom~right(2, 0)
    End

  Return offset
End
Exit

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
initTimezones:
Procedure expose timezones.
Do
  -- Read time zone info from formatted comment block below
  Drop !REGION !FULLNAME !OFFSET !ZNAMEALT
  timezones.0 = 0
  region    = ''
  !datBegin = '__DATA__'
  !datEnd   = '__ENDD__'
  !reading  = isFalse()

  Loop l_ = 1 to sourceline()
    Parse value sourceline(l_) with sl 0 hd +8 .
    If !reading then Do
      If hd = !datEnd then Do
        !reading = isFalse()
        Leave l_
        End
      else Do
        Parse value sl with sl '--' .
        If sl~strip~length = 0 then Iterate l_
        Parse value sl with,
          0 '{' zRegion '}',
          0 zAbbrev . '!' zFullName '!' zAbbrevOther . '!' zUOffset .
          If zRegion~length \= 0 then Do
            region = zRegion
            Iterate l_
            End
          else Do
            z_ = timezones.0 + 1
            timezones.0 = z_
            timezones.z_ = zAbbrev~strip~upper
            timezones.z_.!FULLNAME = zFullName~strip
            timezones.z_.!OFFSET   = zUOffset~format
            timezones.z_.!ZNAMEALT = zAbbrevOther~strip~upper
            timezones.z_.!REGION   = region
            End
        End
      End
    else Do
      If hd = !datBegin then Do
        !reading = isTrue()
        End
      Iterate l_
      End
    End l_

  Return timezones.0
End
Exit
/*
 A "HERE" document, sort of...
 Everything between the __DATA__ and __ENDD__ delimiters will be read into the timezones. stem:

__DATA__
{Universal}
UTC  ! Coordinated Universal Time          !        !   0

{Europe}
BST  ! British Summer Time                 !        !  +1
CEST ! Central European Summer Time        !        !  +2
CET  ! Central European Time               !        !  +1
EEST ! Eastern European Summer Time        !        !  +3
EET  ! Eastern European Time               !        !  +2
GMT  ! Greenwich Mean Time                 !        !   0
IST  ! Irish Standard Time                 !        !  +1
KUYT ! Kuybyshev Time                      !        !  +4
MSD  ! Moscow Daylight Time                !        !  +4
MSK  ! Moscow Standard Time                !        !  +3
SAMT ! Samara Time                         !        !  +4
WEST ! Western European Summer Time        !        !  +1
WET  ! Western European Time               !        !   0

{North America}
ADT  ! Atlantic Daylight Time              ! HAA    !  -3
AKDT ! Alaska Daylight Time                ! HAY    !  -8
AKST ! Alaska Standard Time                ! HNY    !  -9
AST  ! Atlantic Standard Time              ! HNA    !  -4
CDT  ! Central Daylight Time               ! HAC    !  -5
CST  ! Central Standard Time               ! HNC    !  -6
EDT  ! Eastern Daylight Time               ! HAE    !  -4
EGST ! Eastern Greenland Summer Time       !        !   0
EGT  ! East Greenland Time                 !        !  -1
EST  ! Eastern Standard Time               ! HNE,ET !  -5
HADT ! Hawaii-Aleutian Daylight Time       !        !  -9
HAST ! Hawaii-Aleutian Standard Time       !        ! -10
MDT  ! Mountain Daylight Time              ! HAR    !  -6
MST  ! Mountain Standard Time              ! HNR    !  -7
NDT  ! Newfoundland Daylight Time          ! HAT    !  -2.5
NST  ! Newfoundland Standard Time          ! HNT    !  -3.5
PDT  ! Pacific Daylight Time               ! HAP    !  -7
PMDT ! Pierre & Miquelon Daylight Time     !        !  -2
PMST ! Pierre & Miquelon Standard Time     !        !  -3
PST  ! Pacific Standard Time               ! HNP,PT !  -8
WGST ! Western Greenland Summer Time       !        !  -2
WGT  ! West Greenland Time                 !        !  -3

{India and Indian Ocean}
IST  ! India Standard Time                 !        !  +5.5
PKT  ! Pakistan Standard Time              !        !  +5
BST  ! Bangladesh Standard Time            !        !  +6 -- Note: collision with British Summer Time
NPT  ! Nepal Time                          !        !  +5.75
BTT  ! Bhutan Time                         !        !  +6
BIOT ! British Indian Ocean Territory Time ! IOT    !  +6
MVT  ! Maldives Time                       !        !  +5
CCT  ! Cocos Islands Time                  !        !  +6.5
TFT  ! French Southern and Antarctic Time  !        !  +5

__ENDD__
*/
