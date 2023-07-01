|s abbrDict dt|

s := 'March 7 2009 7:30pm EST'.

"Build a abbreviation -> offset for timezones (example)"
abbrDict := Dictionary new.

abbrDict at: 'EST'
         put: { (Duration days: 0 hours: -5 minutes: 0 seconds: 0).
                (DateTime year: 2009 month: 3 day: 8 hour: 2 minute: 0 second: 0).
		(Duration days: 0 hours: 1 minutes: 0 seconds: 0) }.

dt := DateTimeTZ readFromWithMeridian: (s readStream) andTimeZone: abbrDict.

dt := dt + (Duration days: 0 hours: 12 minutes: 0 seconds: 0).

"let's print it"
('%1 %2 %3 %4:%5%6 %7' %
{
  (dt dateTime) monthName asString.
  (dt dateTime) day.
  (dt dateTime) year.
  (dt dateTime) hour12.
  (dt dateTime) minute.
  (dt dateTime) meridianAbbreviation asString.
  dt timeZoneName.
}) displayNl.

(dt dateTime) asUTC displayNl.
