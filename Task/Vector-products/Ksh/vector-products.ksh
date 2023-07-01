#!/bin/ksh

# Vector products
#	# dot product (a scalar quantity) A • B = a1b1 + a2b2 + a3b3  + ...
#	# cross product (a vector quantity) A x B = (a2b3 - a3b2, a3b1 - a1b3, a1b2 - a2b1)
#	# scalar triple product (a scalar quantity) A • (B x C)
#	# vector triple product (a vector quantity) A x (B x C)

#	# Variables:
#
typeset -a A=(  3    4    5 )
typeset -a B=(  4    3    5 )
typeset -a C=( -5  -12  -13 )

#	# Functions:
#

#	# Function _dotprod(vec1, vec2) - Return the (scalar) dot product of 2 vectors
#
function _dotprod {
	typeset _vec1 ; nameref _vec1="$1"	# Input vector 1
	typeset _vec2 ; nameref _vec2="$2"	# Input vector 2
	typeset _i ; typeset -si _i
	typeset _dotp ; integer _dotp=0

	for ((_i=0; _i<${#_vec1[*]}; _i++)); do
		(( _dotp+=(_vec1[_i] * _vec2[_i]) ))
	done
	echo ${_dotp}
}

#	# Function _crossprod(vec1, vec2, vec) - Return the (vector) cross product of 2 vectors
#
function _crossprod {
	typeset _vec1 ; nameref _vec1="$1"	# Input vector 1
	typeset _vec2 ; nameref _vec2="$2"	# Input vector 2
	typeset _vec3 ; nameref _vec3="$3"	# Output vector

	_vec3+=( $(( _vec1[1]*_vec2[2] - _vec1[2]*_vec2[1] )) )
	_vec3+=( $(( _vec1[2]*_vec2[0] - _vec1[0]*_vec2[2] )) )
	_vec3+=( $(( _vec1[0]*_vec2[1] - _vec1[1]*_vec2[0] )) )
}

#	# Function _scal3prod(vec1, vec2, vec3) - Return the (scalar) scalar triple product of 3 vectors
#
function _scal3prod {
	typeset _vec1 ; nameref _vec1="$1"	# Input vector 1
	typeset _vec2 ; nameref _vec2="$2"	# Input vector 2
	typeset _vec3 ; nameref _vec3="$3"	# Input vector 3
	typeset _vect ; typeset -a _vect	# temp vector

	_crossprod _vec2 _vec3 _vect		# (B x C)
	echo $(_dotprod _vec1 _vect)		# A • (B x C)

}

#	# Function _vect3prod(vec1, vec2, vec3, vec) - Return the (vector) vector triple product of 3 vectors
#
function _vect3prod {
	typeset _vec1 ; nameref _vec1="$1"	# Input vector 1
	typeset _vec2 ; nameref _vec2="$2"	# Input vector 2
	typeset _vec3 ; nameref _vec3="$3"	# Input vector 3
	typeset _vec4 ; nameref _vec4="$4"	# Output vector
	typeset _vect ; typeset -a _vect	# temp vector

	_crossprod _vec2 _vec3 _vect		# (B x C)
	_crossprod _vec1 _vect _vec4		# A x (B x C)
}

 ######
# main #
 ######

print "The dot product A • B = $(_dotprod A B)"

typeset -a arr
_crossprod A B arr
print "The cross product A x B = ( ${arr[@]} )"

print "The scalar triple product A • (B x C) = $(_scal3prod A B C)"

typeset -m crossprod=arr ; typeset -a arr
_vect3prod A B C arr
print "The vector triple product A x (B x C) = ( ${arr[@]} )"
