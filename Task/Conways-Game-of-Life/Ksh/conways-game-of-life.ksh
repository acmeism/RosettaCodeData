#!/bin/ksh
#	# Version AJM 93u+ 2012-08-01

# Conway's Game of Life

#	# Variables:
#
integer RAND_MAX=32767
LIFE="�[07m  �[m"
NULL="  "
typeset -a char=( "$NULL" "$LIFE" )

#	# Input x y or default to 30x30, positive integers only
#
integer h=${1:-30} ; h=$(( h<=0 ? 30 : h ))		# Height (y)
integer w=${2:-30} ; w=$(( w<=0 ? 30 : w ))		# Width  (x)

#	# Functions:
#

#	# Function _display(map, h, w)
#
function _display {
	typeset _dmap ; nameref _dmap="$1"
	typeset _h _w ; integer _h=$2 _w=$3

	typeset _x _y ; integer _x _y

	printf %s "�[H"
	for (( _y=0; _y<_h; _y++ )); do
		for (( _x=0; _x<_w; _x++ )); do
			printf %s "${char[_dmap[_y][_x]]}"
		done
		printf "%s\n"
	done
}

#	# Function _evolve(h, w)
#
_evolve() {
	typeset _h _w ; integer _h=$1 _w=$2

	typeset _x _y _n _y1 _x1 ; integer _x _y _n _y1 _x1
	typeset _new _newdef ; typeset -a _new

	for (( _y=0; _y<_h; _y++ )); do
		for (( _x=0; _x<_w; _x++ )); do
			_n=0
			for (( _y1=_y-1; _y1<=_y+1; _y1++ )); do
				for (( _x1=_x-1; _x1<=_x+1; _x1++ )); do
					(( _map[$(( (_y1 + _h) % _h ))][$(( (_x1 + _w) % _w ))] )) && (( _n++ ))
				done
			done
			(( _map[_y][_x] )) && (( _n-- ))
			_new[_y][_x]=$(( (_n==3) || (_n==2 && _map[_y][_x]) ))
		done
	done
	
	for (( _y=0; _y<_h; _y++ )); do
		for (( _x=0; _x<_w; _x++ )); do
			_map[_y][_x]=${_new[_y][_x]}
		done
	done
}

#	# Function _game(h, w)
#
function _game {
	typeset _h ; integer _h=$1
	typeset _w ; integer _w=$2

	typeset _x _y ; integer _x _y
	typeset -a _map

	for (( _y=0 ; _y<_h ; _y++ )); do
		for (( _x=0 ; _x<_h ; _x++ )); do
			_map[_x][_y]=$(( RANDOM < RAND_MAX / 10 ? 1 : 0 ))	# seed map
		done
	done

	while : ; do
		_display _map ${_h} ${_w}
		_evolve ${_h} ${_w}
		sleep 0.2
	done
}

 ######
# main #
 ######

 _game ${h} ${w}
