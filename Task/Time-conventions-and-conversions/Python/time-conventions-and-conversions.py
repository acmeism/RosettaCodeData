#!/bin/python
#!/bin/python
""" " Time system conversions"""

from datetime import datetime, timezone
from math import trunc
from re import sub

UTC_EPOCH = 0
SECS_PER_DAY = 86400
UNIX_EPOCH = datetime(1970, 1, 1).toordinal() * SECS_PER_DAY
NTP_EPOCH = datetime(1900, 1, 1).toordinal() * SECS_PER_DAY
TAI_EPOCH = datetime(1958, 1, 1).toordinal() * SECS_PER_DAY
GPS_EPOCH = datetime(1980, 1, 6).toordinal() * SECS_PER_DAY

NTP_TO_LEAP_SECONDS = {
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
    3692217600: 37,
}

CHANGE_TIMES = sorted(NTP_TO_LEAP_SECONDS.keys())


# The 8 conversions below do not need leap second adjustments


def UTC_to_Unix(utc_string):
    """UTC to Unix timestamp"""
    return datetime.fromisoformat(utc_string).toordinal() * SECS_PER_DAY - UNIX_EPOCH


def UTC_to_NTP(utc_string):
    """UTC to NTP timestamp"""
    return UTC_to_Unix(utc_string) + UNIX_EPOCH - NTP_EPOCH


def NTP_to_Unix(ntp_secs):
    """NTP to Unix timestamp"""
    return ntp_secs + NTP_EPOCH - UNIX_EPOCH


def Unix_to_NTP(unix_secs):
    """Unix to NTP timestamp"""
    return unix_secs + UNIX_EPOCH - NTP_EPOCH


def Unix_to_UTC(unix_secs):
    """Unix to UTC timestamp, keeping UTC as timezone"""
    round_secs = round(unix_secs) == unix_secs
    format = "%Y-%m-%dT%H:%M:%S" if round_secs else "%Y-%m-%dT%H:%M:%S.%f"
    s = datetime.fromtimestamp(unix_secs).astimezone(timezone.utc).strftime(format)
    return s if round_secs else s[:-2]


def NTP_to_UTC(ntp_seconds):
    """NTP to UTC timestamp"""
    return Unix_to_UTC(NTP_to_Unix(ntp_seconds))


def TAI_to_GPS(tai_secs):
    """TAI to GPS timestamp"""
    return tai_secs + TAI_EPOCH - GPS_EPOCH - 19


def GPS_to_TAI(gps_secs):
    """GPS to TAI timestamp"""
    return gps_secs + GPS_EPOCH - TAI_EPOCH + 19


# The next 12 conversions require leap-second adjustments. Since the leap second
#  change timestamps are in NTC for TAI conversions, set up the conversions as
#  between NTP and TAI first and let the other conversions depend on those two.


def NTP_to_TAI(ntp_secs):
    """Convert NTP to TAI, adding leap seconds"""
    tai = ntp_secs + NTP_EPOCH - TAI_EPOCH
    if ntp_secs < CHANGE_TIMES[0]:
        return tai
    if ntp_secs >= CHANGE_TIMES[-1]:
        return tai + NTP_TO_LEAP_SECONDS[CHANGE_TIMES[-1]]
    idx = next(i for i in range(len(CHANGE_TIMES)) if CHANGE_TIMES[i] > ntp_secs)
    return tai + NTP_TO_LEAP_SECONDS[CHANGE_TIMES[idx - 1]]


def TAI_to_NTP(tai_secs):
    """
    Convert TAI to NTP, subtracting leap seconds. Adjust by 1 if ntp time
    subtraction causes time to cross a leap second update.
    """
    ntp = tai_secs + TAI_EPOCH - NTP_EPOCH
    if ntp < CHANGE_TIMES[0]:
        return ntp

    if ntp >= CHANGE_TIMES[-1]:
        delta = NTP_TO_LEAP_SECONDS[CHANGE_TIMES[-1]]
    else:
        idx = next(i for i in range(len(CHANGE_TIMES)) if CHANGE_TIMES[i] > ntp) - 1
        delta = NTP_TO_LEAP_SECONDS[CHANGE_TIMES[idx]]

    if ntp - delta < CHANGE_TIMES[0]:
        return CHANGE_TIMES[0] - 1 + ntp - trunc(ntp)

    return ntp - delta + 1 if ntp - delta < CHANGE_TIMES[idx] else ntp - delta


def NTP_to_GPS(ntp_secs):
    """NTP to GPS timestamp"""
    return TAI_to_GPS(NTP_to_TAI(ntp_secs))


def GPS_to_NTP(gps_secs):
    """GPS to NTP timestamp"""
    return TAI_to_NTP(GPS_to_TAI(gps_secs))


def TAI_to_Unix(tai_secs):
    """TAI to Unix timestamp"""
    return NTP_to_Unix(TAI_to_NTP(tai_secs))


def Unix_to_TAI(unix_secs):
    """Unix to GPS to TAI timestamp"""
    return NTP_to_TAI(Unix_to_NTP(unix_secs))


def TAI_to_UTC(tai_secs):
    """TAI to UTC timestamp"""
    return NTP_to_UTC(TAI_to_NTP(tai_secs))


def UTC_to_TAI(utc_string):
    """UTC to TAI timestamp"""
    return NTP_to_TAI(UTC_to_NTP(utc_string))


def GPS_to_Unix(gps_secs):
    """GPS to Unix timestamp"""
    return TAI_to_Unix(GPS_to_TAI(gps_secs))


def Unix_to_GPS(unix_secs):
    """Unix to GPS timestamp"""
    return TAI_to_GPS(Unix_to_TAI(unix_secs))


def UTC_to_GPS(utc_string):
    """UTC to GPS timestamp"""
    return TAI_to_GPS(UTC_to_TAI(utc_string))


def GPS_to_UTC(gps_secs):
    """GPS to UTC timestamp"""
    return TAI_to_UTC(GPS_to_TAI(gps_secs))


if __name__ == "__main__":
    print(
        "      UTC", " " * 20, "Unix", " " * 16, "NTP", " " * 16, "TAI", " " * 16, "GPS"
    )
    print("_" * 108)

    for s in [
        "0001-01-01T00:00:00",
        "1900-01-01T00:00:00",
        "1958-01-01T00:00:00",
        "1970-01-01T00:00:00",
        "1980-01-06T00:00:00",
        "1989-12-31T00:00:00",
        "1990-01-06T00:00:00",
        "2025-06-01T00:00:00",
        "2050-01-01T00:00:00",
    ]:
        print(
            f"{s:<28}{UTC_to_Unix(s):<21}{UTC_to_NTP(s):<21d}{UTC_to_TAI(s):<21d}{UTC_to_GPS(s):<21d}"
        )

    for un in [
        1810753809.806,
        154956295.688,
        780673454.121,
    ]:
        print(
            f"{Unix_to_UTC(un):<28}{un:<21}{Unix_to_NTP(un):<21.14}{Unix_to_TAI(un):<21.14}{Unix_to_GPS(un):<21.14}"
        )

    for nt in [
        2871676795,
        2335219189,
        3029443171,
        3124137599,
        3124137600,
    ]:
        print(
            f"{NTP_to_UTC(nt):28}{NTP_to_Unix(nt):<21d}{nt:<21d}{NTP_to_TAI(nt):<21d}{NTP_to_GPS(nt):<21d}"
        )

    for ta in [
        996796823,
        996796824,
        996796825,
        996796826,
        1293840030,
        1293840031,
        1293840032,
        1293840033,
    ]:
        print(
            f"{TAI_to_UTC(ta):28}{TAI_to_Unix(ta):<21}{TAI_to_NTP(ta):<21}{ta:<21}{TAI_to_GPS(ta):<21}"
        )

    for gp in [
        996796804.250,
        996796805.5,
        996796806.750,
        996796807.9999,
    ]:
        print(
            f"{GPS_to_UTC(gp):28}{GPS_to_Unix(gp):<21.14}{GPS_to_NTP(gp):<21.14}{GPS_to_TAI(gp):<21.14}{gp:<21.14}"
        )
