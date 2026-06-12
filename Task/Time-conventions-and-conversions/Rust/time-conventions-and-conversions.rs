using NanoDates
using Printf

# internal calculations are in nanoseconds for a NanoDate
const SECONDS_PER_DAY = 86400
const NANOSECONDS_PER_SECOND = Int128(1_000_000_000)
const NANOSECONDS_PER_MILLISECOND = Int128(1_000_000)
const UNIX_EPOCH_NANOSECONDS = 62135683200 * NANOSECONDS_PER_SECOND
const NTP_EPOCH_NANOSECONDS = 59926694400 * NANOSECONDS_PER_SECOND
const TAI_EPOCH_NANOSECONDS = 61756992000 * NANOSECONDS_PER_SECOND
const GPS_EPOCH_NANOSECONDS = 62451648000 * NANOSECONDS_PER_SECOND
const TAI_GPS_DIFFERENCE_NANOSECONDS = 19 * NANOSECONDS_PER_SECOND
const NTP_TO_LEAP_SECONDS = [
    (2272060800, 10),
    (2287785600, 11),
    (2303683200, 12),
    (2335219200, 13),
    (2366755200, 14),
    (2398291200, 15),
    (2429913600, 16),
    (2461449600, 17),
    (2492985600, 18),
    (2524521600, 19),
    (2571782400, 20),
    (2603318400, 21),
    (2634854400, 22),
    (2698012800, 23),
    (2776982400, 24),
    (2840140800, 25),
    (2871676800, 26),
    (2918937600, 27),
    (2950473600, 28),
    (2982009600, 29),
    (3029443200, 30),
    (3076704000, 31),
    (3124137600, 32),
    (3345062400, 33),
    (3439756800, 34),
    (3550089600, 35),
    (3644697600, 36),
    (3692217600, 37),
];

"""
Finds the index of the leap second that should be used based on the given NTP time in seconds.
"""
function leap_seconds_current_index(ntp_secs)
    ntp_secs < NTP_TO_LEAP_SECONDS[begin][begin] && return nothing
    for (i, pair) in enumerate(NTP_TO_LEAP_SECONDS)
        ntp_secs < pair[begin] && return i - 1
    end
    return length(NTP_TO_LEAP_SECONDS) - 1
end

from_utc(utc_string::AbstractString) = NanoDate(utc_string)
from_unix(unix_secs::Integer) =
    NanoDate(unix_secs * NANOSECONDS_PER_SECOND + UNIX_EPOCH_NANOSECONDS)
from_unix(unix_secs) =
    NanoDate((Int128(round(unix_secs * NANOSECONDS_PER_SECOND)) + UNIX_EPOCH_NANOSECONDS))
from_ntp(ntp_secs::Integer) =
    NanoDate(ntp_secs * NANOSECONDS_PER_SECOND + NTP_EPOCH_NANOSECONDS)
from_ntp(ntp_secs) =
    NanoDate(round(ntp_secs * NANOSECONDS_PER_SECOND) + NTP_EPOCH_NANOSECONDS)

function from_tai_nsec(tai_nsec::Int128)
    ntp_secs =
        (tai_nsec + TAI_EPOCH_NANOSECONDS - NTP_EPOCH_NANOSECONDS) ÷ NANOSECONDS_PER_SECOND
    nsecs = tai_nsec % NANOSECONDS_PER_SECOND
    idx = leap_seconds_current_index(ntp_secs)
    isnothing(idx) &&
        return NanoDate(ntp_secs * NANOSECONDS_PER_SECOND + nsecs + NTP_EPOCH_NANOSECONDS)
    delta = NTP_TO_LEAP_SECONDS[idx][end]
    return NanoDate(
        (
            ntp_secs - delta < NTP_TO_LEAP_SECONDS[begin][begin] ?
            NANOSECONDS_PER_SECOND * NTP_TO_LEAP_SECONDS[begin][begin] -
            NANOSECONDS_PER_SECOND + (tai_nsec % NANOSECONDS_PER_SECOND) :
            ntp_secs - delta < NTP_TO_LEAP_SECONDS[idx][begin] ?
            (ntp_secs - delta) * NANOSECONDS_PER_SECOND + NANOSECONDS_PER_SECOND + nsecs :
            (ntp_secs - delta) * NANOSECONDS_PER_SECOND + nsecs
        ) + NTP_EPOCH_NANOSECONDS,
    )
end
from_tai(tai_secs::Integer) = from_tai_nsec(tai_secs * NANOSECONDS_PER_SECOND)
from_tai(tai_secs) = from_tai_nsec(Int128(round(tai_secs * NANOSECONDS_PER_SECOND)))



function from_gps_nsec(gps_nsecs::Int128)
    return from_tai_nsec(
        gps_nsecs + GPS_EPOCH_NANOSECONDS - TAI_EPOCH_NANOSECONDS +
        TAI_GPS_DIFFERENCE_NANOSECONDS,
    )
end
from_gps(gps_secs::Integer) = from_gps_nsec(gps_secs * NANOSECONDS_PER_SECOND)
from_gps(gps_secs) = from_gps_nsec(Int128(round(gps_secs * NANOSECONDS_PER_SECOND)))


function to_utc(nd::NanoDate; precision = 3)
    fmt = Printf.Format("%07.$(precision)f")
    s = string(nd)
    return replace(
        s,
        r"(\d\d\.\d+)" => (ns) -> Printf.format(fmt, parse(Float64, ns))
    )
end

function to_unix(nd::NanoDate)
    return NanoDates.value(nd) % NANOSECONDS_PER_SECOND == 0 ?
           (NanoDates.value(nd) - UNIX_EPOCH_NANOSECONDS) ÷ NANOSECONDS_PER_SECOND :
           (NanoDates.value(nd) - UNIX_EPOCH_NANOSECONDS) / NANOSECONDS_PER_SECOND
end

function to_ntp(nd::NanoDate)
    return NanoDates.value(nd) % NANOSECONDS_PER_SECOND == 0 ?
           (NanoDates.value(nd) - NTP_EPOCH_NANOSECONDS) ÷ NANOSECONDS_PER_SECOND :
           (NanoDates.value(nd) - NTP_EPOCH_NANOSECONDS) / NANOSECONDS_PER_SECOND
end

function to_tai_nsec(nd::NanoDate)
    ntp_sec = (NanoDates.value(nd) - NTP_EPOCH_NANOSECONDS) / NANOSECONDS_PER_SECOND
    idx = leap_seconds_current_index(ntp_sec)
    return idx == nothing ? NanoDates.value(nd) - TAI_EPOCH_NANOSECONDS :
           NanoDates.value(nd) - TAI_EPOCH_NANOSECONDS +
           NANOSECONDS_PER_SECOND * NTP_TO_LEAP_SECONDS[idx][end]
end

function to_tai(nd::NanoDate)
    tai_nsec = to_tai_nsec(nd)
    return tai_nsec % NANOSECONDS_PER_SECOND == 0 ?
           tai_nsec ÷ NANOSECONDS_PER_SECOND :
           tai_nsec / NANOSECONDS_PER_SECOND
end

function to_gps(nd::NanoDate)
    gps_nsec =
        to_tai_nsec(nd) + TAI_EPOCH_NANOSECONDS - GPS_EPOCH_NANOSECONDS -
        TAI_GPS_DIFFERENCE_NANOSECONDS
    return gps_nsec % NANOSECONDS_PER_SECOND == 0 ?
           gps_nsec ÷ NANOSECONDS_PER_SECOND :
           gps_nsec / NANOSECONDS_PER_SECOND
end

"""
    print_stamps(nd::NanoDate, s, str_idx; precision = "3", sfmt = Printf.Format("%.3f"))

Prints formatted timestamp information based on the given `NanoDate` object.

# Arguments
- `nd::NanoDate`: The date and time to be formatted and printed.
- `s`: A string to be printed when `str_idx` matches the index.
- `str_idx`: An integer indicating which string index to print.
- `precision`: A string specifying the desired precision for the UTC representation. Defaults to "3".
- `sfmt`: A `Printf.Format` object specifying the format for floating-point numbers. Defaults to `Printf.Format("%.3f")`.

# Description
The function prints out various time representations of the given `NanoDate` object `nd`. It uses `str_idx` to determine which string to print, and formats the output based on whether the time is an integer second or not. The representations include UTC, Unix, NTP, TAI, and GPS time formats.
"""
function print_stamps(
    nd::NanoDate,
    s,
    str_idx;
    precision = "3",
    sfmt = Printf.Format("%.3f"),
)
    int = NanoDates.value(nd) % NANOSECONDS_PER_SECOND == 0
    print(rpad(str_idx == 1 ? s : to_utc(nd; precision), 26))
    print(rpad(str_idx == 2 ? s : int ? to_unix(nd) : Printf.format(sfmt, to_unix(nd)), 17))
    print(rpad(str_idx == 3 ? s : int ? to_ntp(nd) : Printf.format(sfmt, to_ntp(nd)), 17))
    print(rpad(str_idx == 4 ? s : int ? to_tai(nd) : Printf.format(sfmt, to_tai(nd)), 17))
    println(rpad(str_idx == 5 ? s : int ? to_gps(nd) : Printf.format(sfmt, to_gps(nd)), 17))
end

"""
    timestamp_conversions()

Converts and prints timestamp information across various time standards including UTC, Unix, NTP, TAI, and GPS.

The function performs the following steps:

- Prints a header with the names of the time standards.
- Iterates over a list of predefined UTC timestamps, converting each to a normalized date and time, and prints the results.
- Converts and prints a specific floating-point UTC timestamp.
- Converts and prints a list of Unix timestamps.
- Converts and prints a list of NTP timestamps.
- Converts and prints a list of TAI timestamps.
- Converts and prints a list of GPS timestamps with specified precision.

Each conversion relies on helper functions (`from_utc`, `from_unix`, `from_ntp`, `from_tai`, `from_gps`) to parse and convert the timestamps, and `print_stamps` to format and display the results.
"""
function timestamp_conversions()
    @printf("%17s%13s%22s%16s%17s\n", "UTC", "Unix", "NTP", "TAI", "GPS")
    println("_"^96)

    for s in [
        "0001-01-01T00:00:00",
        "1900-01-01T00:00:00",
        "1958-01-01T00:00:00",
        "1970-01-01T00:00:00",
        "1980-01-06T00:00:00",
        "1989-12-31T00:00:00",
        "1990-01-01T00:00:00",
        "2025-06-01T00:00:00",
        "2050-01-01T00:00:00",
    ]
        nd = from_utc(s)
        isnothing(nd) && throw("Parse error parsing $s")
        print_stamps(nd, s, 1)
    end

    floating = "1900-01-01T00:00:07.36"
    nd = from_utc(floating)
    isnothing(nd) && throw("Parse error parsing $floating")
    print_stamps(nd, floating, 1)

    for unix in [1810753809.806, 154956295.688, 780673454.121]
        nd = from_unix(unix)
        print_stamps(nd, @sprintf("%.3f", unix), 2)
    end

    for ntp in [2871676795, 2335219189, 3029443171]
        nd = from_ntp(ntp)
        print_stamps(nd, string(ntp), 3)
    end

    for tai in [996796823, 996796824, 996796825, 996796826, 1293840030, 1293840031, 1293840032, 1293840033,]
        nd = from_tai(tai)
        print_stamps(nd, string(tai), 4)
    end

    for gps in [996796804.250, 996796805.5, 996796806.750, 996796807.9999]
        nd = from_gps(gps)
        print_stamps(
            nd,
            @sprintf("%.4f", gps),
            5,
            precision = "4",
            sfmt = Printf.Format("%.4f"),
        )
    end
end

timestamp_conversions()
