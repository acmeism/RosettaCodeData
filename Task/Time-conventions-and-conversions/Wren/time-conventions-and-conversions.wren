import "./date" for Date
import "./fmt" for Fmt

var UNIX_EPOCH = Date.unixEpoch.number / 1000
var NTP_EPOCH  = Date.new(1900, 1, 1).number / 1000
var TAI_EPOCH  = Date.new(1958, 1, 1).number / 1000
var GPS_EPOCH  = Date.new(1980, 1, 6).number / 1000

var NTP_TO_LS = {
    2272060800: 10,
    2287785600: 11,
    2303683200: 12,
    2335219200: 13,
    2366755200: 14,
    2398291200: 15,
    2429913600: 16,
    2461449600: 17,
    2492985600: 18,
    2524521600: 19,
    2571782400: 20,
    2603318400: 21,
    2634854400: 22,
    2698012800: 23,
    2776982400: 24,
    2840140800: 25,
    2871676800: 26,
    2918937600: 27,
    2950473600: 28,
    2982009600: 29,
    3029443200: 30,
    3076704000: 31,
    3124137600: 32,
    3345062400: 33,
    3439756800: 34,
    3550089600: 35,
    3644697600: 36,
    3692217600: 37
}

var CHANGE_TIMES = NTP_TO_LS.keys.toList.sort()

// The 8 conversions below do not need leap second adjustments.

var utc2unix = Fn.new { |utcStr| Date.parse(utcStr).number/1000 - UNIX_EPOCH }

var utc2ntp  = Fn.new { |utcStr| utc2unix.call(utcStr) + UNIX_EPOCH - NTP_EPOCH }

var ntp2unix = Fn.new { |ntpSecs| ntpSecs + NTP_EPOCH - UNIX_EPOCH }

var unix2ntp = Fn.new { |unixSecs| unixSecs + UNIX_EPOCH - NTP_EPOCH }

var unix2utc = Fn.new { |unixSecs| Date.fromNumber((unixSecs + UNIX_EPOCH) * 1000).toString }

var ntp2utc  = Fn.new { |ntpSecs| unix2utc.call(ntp2unix.call(ntpSecs)) }

var tai2gps  = Fn.new { |taiSecs| taiSecs + TAI_EPOCH - GPS_EPOCH - 19 }

var gps2tai  = Fn.new { |gpsSecs| gpsSecs + GPS_EPOCH - TAI_EPOCH + 19 }

/*
    The next 12 conversions require leap-second adjustments. Since the leap second
    change timestamps are in NTC for TAI conversions, set up the conversions as
    between NTP and TAI first and let the other conversions depend on those two.
*/

// Convert NTP to TAI, adding leap seconds.
var ntp2tai = Fn.new { |ntpSecs|
    var tai = ntpSecs + NTP_EPOCH - TAI_EPOCH
    if (ntpSecs < CHANGE_TIMES[0]) return tai
    if (ntpSecs >= CHANGE_TIMES[-1]) return tai + NTP_TO_LS[CHANGE_TIMES[-1]]
    for (i in 1...CHANGE_TIMES.count) {
        if (ntpSecs < CHANGE_TIMES[i]) return tai + NTP_TO_LS[CHANGE_TIMES[i-1]]
    }
}

// Convert TAI to NTP, subtracting leap seconds. Adjust by 1 if ntp time
// subtraction causes time to cross a leap second update.
var tai2ntp = Fn.new { |taiSecs|
    var ntp = taiSecs + TAI_EPOCH - NTP_EPOCH
    if (ntp < CHANGE_TIMES[0]) return ntp
    var idx = 0
    var delta = 0
    if (ntp >= CHANGE_TIMES[-1]) {
        delta = NTP_TO_LS[CHANGE_TIMES[-1]]
    } else {
        for (i in 1...CHANGE_TIMES.count) {
            if (ntp < CHANGE_TIMES[i]) {
                delta = NTP_TO_LS[CHANGE_TIMES[i-1]]
                idx = i
                break
            }
        }
    }
    if (ntp - delta < CHANGE_TIMES[0]) return CHANGE_TIMES[0] - 1 + ntp.fraction
    if (ntp - delta < CHANGE_TIMES[idx-1]) return ntp - delta + 1
    return ntp - delta
}

var ntp2gps  = Fn.new { |ntpSecs| tai2gps.call(ntp2tai.call(ntpSecs)) }

var gps2ntp  = Fn.new { |gpsSecs| tai2ntp.call(gps2tai.call(gpsSecs)) }

var tai2unix = Fn.new { |taiSecs| ntp2unix.call(tai2ntp.call(taiSecs)) }

var unix2tai = Fn.new { |unixSecs| ntp2tai.call(unix2ntp.call(unixSecs)) }

var tai2utc  = Fn.new { |taiSecs| ntp2utc.call(tai2ntp.call(taiSecs)) }

var utc2tai  = Fn.new { |utcStr| ntp2tai.call(utc2ntp.call(utcStr)) }

var gps2unix = Fn.new { |gpsSecs| tai2unix.call(gps2tai.call(gpsSecs)) }

var unix2gps = Fn.new { |unixSecs| tai2gps.call(unix2tai.call(unixSecs)) }

var utc2gps  = Fn.new { |utcStr| tai2gps.call(utc2tai.call(utcStr)) }

var gps2utc  = Fn.new { |gpsSecs| tai2utc.call(gps2tai.call(gpsSecs)) }

Fmt.print("      UTC                   Unix              NTP               TAI               GPS")
Fmt.print("_" * 95)
var f = "$-23s $17.4h $17.4h $17.4h $17.4h"
for (s in ["0001-01-01T00:00:00", "1900-01-01T00:00:00", "1958-01-01T00:00:00",
              "1970-01-01T00:00:00", "1980-01-06T00:00:00", "1989-12-31T00:00:00",
              "1990-01-06T00:00:00", "2025-06-01T00:00:00", "2050-01-01T00:00:00"]) {
    Fmt.print(f, s, utc2unix.call(s), utc2ntp.call(s), utc2tai.call(s), utc2gps.call(s))
}

for (un in [1810753809.806, 154956295.688, 780673454.121]) {
    var dt = unix2utc.call(un).replace(" ", "T")
    Fmt.print(f, dt, un, unix2ntp.call(un), unix2tai.call(un), unix2gps.call(un))
}

for (nt in [2871676795, 2335219189, 3029443171, 3124137599, 3124137600]) {
    var dt = ntp2utc.call(nt).replace(" ", "T")
    Fmt.print(f, dt, ntp2unix.call(nt), nt, ntp2tai.call(nt), ntp2gps.call(nt))
}

for (ta in [996796823, 996796824, 996796825, 996796826, 1293840030,
            1293840031, 1293840032, 1293840033]) {
    var dt = tai2utc.call(ta).replace(" ", "T")
    Fmt.print(f, dt, tai2unix.call(ta), tai2ntp.call(ta), ta, tai2gps.call(ta))
}

for (gp in [996796804.250, 996796805.5, 996796806.750, 996796807.9999] ) {
    var dt = gps2utc.call(gp).replace(" ", "T")
    Fmt.print(f, dt, gps2unix.call(gp), gps2ntp.call(gp), gps2tai.call(gp), gp)
}
