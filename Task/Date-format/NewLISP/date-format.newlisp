; file:   date-format.lsp
; url:    http://rosettacode.org/wiki/Date_format
; author: oofoe 2012-02-01

; The "now" function returns the current time as a list. A time zone
; offset in minutes can be supplied. The example below is for Eastern
; Standard Time. NewLISP's implicit list indexing is used to extract
; the first three elements of the returned list (year, month and day).

(setq n (now (* -5 60)))
(println "short: " (format "%04d-%02d-%02d" (n 0) (n 1) (n 2)))

; The "date-value" function returns the time in seconds from the epoch
; when used without arguments. The "date" function converts the
; seconds into a time representation specified by the format string at
; the end. The offset argument ("0" in this example) specifies a
; time-zone offset in minutes.

(println "short: " (date (date-value) 0 "%Y-%m-%d"))

; The time formatting is supplied by the underlying C library, so
; there may be differences on certain platforms. Particularly, leading
; zeroes in day numbers can be suppressed with "%-d" on Linux and
; FreeBSD, "%e" on OpenBSD, SunOS/Solaris and Mac OS X. Use "%#d" for
; Windows.

(println "long:  " (date (date-value) 0 "%A, %B %#d, %Y"))

; By setting the locale, the date will be displayed appropriately:

(set-locale "japanese")
(println "long:  " (date (date-value) 0 "%A, %B %#d, %Y"))

(exit)
