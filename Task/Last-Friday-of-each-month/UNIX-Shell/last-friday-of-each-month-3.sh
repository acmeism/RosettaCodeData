#!/bin/sh

# Free code, no limit work
# $Id: lastfridays,v 1.1 2011/11/10 00:48:16 gilles Exp gilles $

# usage :
# lastfridays 2012 # prints last fridays of months of year 2012

debug=${debug:-false}
#debug=true

epoch_year_day() {
	#set -x
	x_epoch=`expr ${2:-0} '*' 86400 + 43200`
	date --date="${1:-1970}-01-01 UTC $x_epoch seconds" +%s
}

year_of_epoch() {
	date --date="1970-01-01 UTC ${1:-0} seconds" +%Y
}
day_of_epoch() {
	LC_ALL=C date --date="1970-01-01 UTC ${1:-0} seconds" +%A
}
date_of_epoch() {
	date --date="1970-01-01 UTC ${1:-0} seconds" "+%Y-%m-%d"
}
month_of_epoch() {
	date --date="1970-01-01 UTC ${1:-0} seconds" "+%m"
}

last_fridays() {
	year=${1:-2012}

        next_year=`expr $year + 1`
        $debug && echo "next_year $next_year"

        current_year=$year
        day=0
        previous_month=01

        while test $current_year != $next_year; do

        	$debug && echo "day $day"

        	current_epoch=`epoch_year_day $year $day`
        	$debug && echo "current_epoch $current_epoch"

        	current_year=`year_of_epoch $current_epoch`

        	current_day=`day_of_epoch $current_epoch`
        	$debug && echo "current_day $current_day"

        	test $current_day = 'Friday' && current_friday=`date_of_epoch $current_epoch`
        	$debug && echo "current_friday $current_friday"

        	current_month=`month_of_epoch $current_epoch`
        	$debug && echo "current_month $current_month"

        	# Change of month => previous friday is the last of month
        	test "$previous_month" != "$current_month" \
        		&& echo $previous_friday
        	
        	previous_month=$current_month
        	previous_friday=$current_friday
        	day=`expr $day + 1`
        done
}

# main
last_fridays ${1:-2012}
