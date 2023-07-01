# define the layout of the date/time as provided by the call to local time #
STRUCT ( INT sec, min, hour, mday, mon, year, wday, yday, isdst) tm = (6,5,4,3,2,1,7,~,8);

FORMAT # some useful format declarations #
  ymd repr = $4d,"-"2d,"-"2d$,
  month repr =    $c("January","February","March","April","May","June","July",
                     "August","September","October","November","December")$,
  week day repr = $c("Sunday","Monday","Tuesday","Wednesday",
                     "Thursday","Friday","Saturday")$,
  dmdy repr =     $f(week day repr)", "f(month repr)" "g(-0)", "g(-4)$,

  mon  = $c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")$,
  wday = $c("Sun","Mon","Tue","Wed","Thu","Fri","Sat")$,
  tz   = $c("MSK","MSD")$,
  unix time repr = $f(wday)" "f(mon)z-d," "dd,":"dd,":"dd," "f(tz)" "dddd$;

[]INT now = local time;

printf((ymd repr,       now[year OF tm:mday OF tm], $l$));
printf((dmdy repr,      now[wday OF tm], now[mon OF tm], now[mday OF tm], now[year OF tm], $l$));

printf((unix time repr, now[wday OF tm], now[mon OF tm], now[mday OF tm],
                        now[hour OF tm:sec OF tm], now[isdst OF tm]+1, now[year OF tm], $l$))
