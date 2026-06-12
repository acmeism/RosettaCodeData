# 20241023 Raku programming solution

my (\UNIX_EPOCH, \NTP_EPOCH, \TAI_EPOCH, \GPS_EPOCH) = map { DateTime.new: $_ },
   < 1970-01-01  1900-01-01  1958-01-01  1980-01-06 >;

my %NTP_TO_LS = ( my @CHANGE_TIMES = <
   2272060800 2287785600 2303683200 2335219200 2366755200 2398291200 2429913600
   2461449600 2492985600 2524521600 2571782400 2603318400 2634854400 2698012800
   2776982400 2840140800 2871676800 2918937600 2950473600 2982009600 3029443200
   3076704000 3124137600 3345062400 3439756800 3550089600 3644697600 3692217600
> ) Z=> 10 .. * ;

# The conversions without leap second adjustments

my &utc2unix = -> $utcStr {
   do given DateTime.new($utcStr).posix { * < 0 ?? $_ !! $_ - UNIX_EPOCH }
}

my &utc2ntp  = -> $utcStr   { utc2unix($utcStr) + UNIX_EPOCH - NTP_EPOCH }

my &ntp2unix = -> $ntpSecs  { $ntpSecs + NTP_EPOCH - UNIX_EPOCH }

my &unix2ntp = -> $unixSecs { $unixSecs + UNIX_EPOCH - NTP_EPOCH }

my &unix2utc = -> $unixSecs { Instant.from-posix($unixSecs).DateTime }

my &ntp2utc  = -> $ntpSecs  { unix2utc(ntp2unix($ntpSecs)) }

my &tai2gps  = -> $taiSecs  { $taiSecs + TAI_EPOCH - GPS_EPOCH - 10 }

my &gps2tai  = -> $gpsSecs  { $gpsSecs + GPS_EPOCH - TAI_EPOCH + 10 }

# Conversions requiring leap-second adjustments

my &ntp2tai = sub ($ntpSecs) {
   my $tai =  $ntpSecs + NTP_EPOCH - TAI_EPOCH;

   return $tai if $ntpSecs < @CHANGE_TIMES[0];

   return $tai+%NTP_TO_LS{@CHANGE_TIMES[*-1]} if $ntpSecs >= @CHANGE_TIMES[*-1];

   for 1 .. @CHANGE_TIMES.elems - 1 {
      if $ntpSecs < @CHANGE_TIMES[$_] {
         return $tai + %NTP_TO_LS{@CHANGE_TIMES[$_-1]}
      }
   }
}

my &tai2ntp = sub ($taiSecs) {
   my $ntp = $taiSecs + TAI_EPOCH - NTP_EPOCH;

   return $ntp if $ntp < @CHANGE_TIMES[0];

   my ($idx, $delta) = (0, 0);

   if $ntp >= @CHANGE_TIMES[*-1] {
      $delta = %NTP_TO_LS{@CHANGE_TIMES[*-1]}
   } else {
      for 1 .. @CHANGE_TIMES.elems - 1 {
         if $ntp < @CHANGE_TIMES[$_] {
            $delta = %NTP_TO_LS{@CHANGE_TIMES[$_-1]};
            $idx = $_;
            last;
         }
      }
   }

   return do given $ntp - $delta {
      when * < @CHANGE_TIMES[0]      { @CHANGE_TIMES[0] - 1 + $ntp.fraction }
      when * < @CHANGE_TIMES[$idx-1] { $_ + 1 }
      default                        { $_ }
   }
}

my &ntp2gps  = -> $ntpSecs  { tai2gps(ntp2tai($ntpSecs)) }

my &gps2ntp  = -> $gpsSecs  { tai2ntp(gps2tai($gpsSecs)) }

my &tai2unix = -> $taiSecs  { ntp2unix(tai2ntp($taiSecs)) }

my &unix2tai = -> $unixSecs { ntp2tai(unix2ntp($unixSecs)) }

my &tai2utc  = -> $taiSecs  { ntp2utc(tai2ntp($taiSecs)) }

my &utc2tai  = -> $utcStr   { ntp2tai(utc2ntp($utcStr)) }

my &gps2unix = -> $gpsSecs  { tai2unix(gps2tai($gpsSecs)) }

my &unix2gps = -> $unixSecs { tai2gps(unix2tai($unixSecs)) }

my &utc2gps  = -> $utcStr   { tai2gps(utc2tai($utcStr)) }

my &gps2utc  = -> $gpsSecs  { tai2utc(gps2tai($gpsSecs)) }

# Output formatting
say "      UTC                            Unix               NTP               TAI               GPS";
say '_' x 100;

my $fmt = "%-28s%18.4f%18.4f%18.4f%18.4f\n";

for < 0001-01-01T00:00:00 1900-01-01T00:00:00 1958-01-01T00:00:00
      1970-01-01T00:00:00 1980-01-06T00:00:00 1989-12-31T00:00:00
      1990-01-06T00:00:00 2025-06-01T00:00:00 2050-01-01T00:00:00 > {
   printf $fmt, $_, .&utc2unix, .&utc2ntp, .&utc2tai, .&utc2gps
}

for < 1810753809.806 154956295.688 780673454.121 > {
   printf $fmt, .&unix2utc, $_, .&unix2ntp, .&unix2tai, .&unix2gps
}

for < 2871676795 2335219189 3029443171 3124137599 3124137600 > {
   printf $fmt, .&ntp2utc, .&ntp2unix, $_, .&ntp2tai, .&ntp2gps
}

for <  996796823  996796824  996796825  996796826
      1293840030 1293840031 1293840032 1293840033 > {
   printf $fmt, .&tai2utc, .&tai2unix, .&tai2ntp, $_, .&tai2gps
}

for < 996796804.250 996796805.5 996796806.750 996796807.9999 > {
   printf $fmt, .&gps2utc, .&gps2unix, .&gps2ntp, .&gps2tai, $_
}
