USING: calendar calendar.format io kernel lists lists.lazy
sequences sets ;

: palindrome-dates ( -- list )
    2020 2 2 <date> [ 1 days time+ ] lfrom-by
    [ timestamp>ymd ] lmap-lazy
    [ "-" without dup reverse = ] lfilter ;

15 palindrome-dates ltake [ print ] leach
