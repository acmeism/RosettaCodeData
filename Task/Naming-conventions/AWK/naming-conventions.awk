# Field names begin with $ so $1 is the first field, $2 the second and $NF the
# last.  $0 references the entire input record.
#
# Function and variable names are case sensitive and begin with an alphabetic
# character or underscore followed by any number of: a-z, A-Z, 0-9, _
#
# The awk language is type less; variables are either string or number
# depending upon usage.  Variables can be coerced to string by concatenating ""
# or to number by adding zero.  For example:
#   str = x ""
#   num = x + 0
#
# Below are the names of the built-in functions, built-in variables and other
# reserved words in the awk language separated into categories.  Also shown are
# the names of gawk's enhancements.
#
# patterns:
#   BEGIN END
#   BEGINFILE ENDFILE (gawk)
# actions:
#   break continue delete do else exit for if in next return while
#   case default switch (gawk)
# arithmetic functions:
#   atan2 cos exp int log rand sin sqrt srand
# bit manipulation functions:
#   and compl lshift or rshift xor (gawk)
# i18n functions:
#   bindtextdomain dcgettext dcngettext (gawk)
# string functions:
#   gsub index length match split sprintf sub substr tolower toupper
#   asort asorti gensub patsplit strtonum (gawk)
# time functions:
#   mktime strftime systime (gawk)
# miscellaneous functions:
#   isarray (gawk)
# variables:
#   ARGC ARGV CONVFMT ENVIRON FILENAME FNR FS NF NR OFMT OFS ORS RLENGTH RS RSTART SUBSEP
#   ARGIND BINMODE ERRNO FIELDWIDTHS FPAT FUNCTAB IGNORECASE LINT PREC PROCINFO ROUNDMODE RT SYMTAB TEXTDOMAIN (gawk)
# function definition:
#   func function
# input-output:
#   close fflush getline nextfile print printf system
# pre-processor directives:
#   @include @load (gawk)
# special files:
#   /dev/stdin /dev/stdout /dev/error
