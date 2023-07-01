  sampleDate = 'March 7 2009 7:30pm EST'

  Parse var sampleDate month day year time zone
  basedate = .DateTime~fromNormalDate(day month~left(3) year)
  basetime = .DateTime~fromCivilTime(time)
  -- this will give us this in a merged format...now we can add in the
  -- timezone informat
  mergedTime = (basedate + basetime~timeofday)~isoDate
  zone = .TimeZoneDataBase~getTimeZone(zone)

  finalTime = .DateTime~fromIsoDate(mergedTime, zone~datetimeOffset)

  say 'Original date:' finalTime~utcIsoDate
  say 'Result after adding 12 hours:' finalTime~addHours(12)~utcIsoDate
  say 'Result shifted to UTC:' finalTime~toTimeZone(0)~utcIsoDate
  say 'Result shifted to Pacific Standard Time:' finalTime~toTimeZone(.TimeZoneDataBase~getTimeZone('PST')~datetimeOffset)~utcIsoDate
  say 'Result shifted to NepalTime Time:' finalTime~toTimeZone(.TimeZoneDataBase~getTimeZone('NPT')~datetimeOffset)~utcIsoDate

-- a descriptor for timezone information
::class timezone
::method init
  expose code name offset altname region
  use strict arg code, name, offset, altname, region
  code~upper

::attribute code GET
::attribute name GET
::attribute offset GET
::attribute altname GET
::attribute region GET
::attribute datetimeOffset GET
  expose offset
  return offset * 60

-- our database of timezones
::class timezonedatabase
-- initialize the class object.  This occurs when the program is first loaded
::method init class
  expose timezones

  timezones = .directory~new
  -- extract the timezone data which is conveniently stored in a method
  data = self~instanceMethod('TIMEZONEDATA')~source

  loop line over data
    -- skip over the comment delimiters, blank lines, and the 'return'
    -- lines that force the comments to be included in the source
    if line = '/*' | line = '*/' | line = '' | line = 'return' then iterate
    parse var line '{' region '}'
    if region \= '' then do
       zregion = region
       iterate
    end
    else do
       parse var line abbrev . '!' fullname '!' altname . '!' offset .
       timezone = .timezone~new(abbrev, fullname, offset, altname, zregion)
       timezones[timezone~code] = timezone
    end
  end

::method getTimezone class
  expose timezones
  use strict arg code
  return timezones[code~upper]

-- this is a dummy method containing the timezone database data.
-- we'll access the source directly and extract the data held in comments
-- the two return statements force the comment lines to be included in the
-- source rather than processed as part of comments between directives
::method timeZoneData class private
return
/*
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
*/
return
