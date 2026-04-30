#!/usr/bin/env  tclsh

# Tcl implementation of Chaocipher
#    (John F. Byrne, 1918)
#
# from paper "CHAOCIPHER REVEALED: THE ALGORITHM"
#    (Moshe Rubin, 2010)
#    http://www.mountainvistasoft.com/chaocipher/ActualChaocipher/Chaocipher-Revealed-Algorithm.pdf
#

# ============ globals "wheels" ============
variable l_key  {HXUCZVAMDSLKPEFJRIGTWOBNYQ}
variable r_key  {PTLNBQDEOYSFAVZKGJRIHWXUMC}



# ============ procedures ==================


# swap range of n letters from end to front
proc permute {alpha  n } {

    set  A [string range $alpha 0 $n-1 ]
    set  B [string range $alpha $n end ]

    return "${B}${A}"
}


# rotate based on key in right alphabet
# (permute each by same amnount)
proc rotate { left right key } {

    set idx [string first $key $right]

    set L   [permute $left $idx ]

    set R   [permute $right $idx]

    return [list $L $R]
}


# split and rearrange each alphabet
# according to recipe
proc cycle { left right } {

    # (0)(2-13)(1)(14-25)
    set l1 [string index $left 0     ]
    set l2 [string range $left 2 13  ]
    set l3 [string index $left 1     ]
    set l4 [string range $left 14 end]

    set L [join [list $l1 $l2 $l3 $l4] ""]

    # (1-2)(4-14)(3)(15-25)(0)
    set r1 [string range $right 1  2  ]
    set r2 [string range $right 4  14 ]
    set r3 [string index $right 3     ]
    set r4 [string range $right 15 end]
    set r5 [string index $right 0     ]

    set R [join [list $r1 $r2 $r3 $r4 $r5] ""]

    return [list $L $R]
}


# rotate wheels and generate cipher text or
# recover plain text
proc chao { input left right mode verbose } {

    set out {}

    set wheels {}

    set len [string length $input]

    if { $verbose } {
	    puts stdout "input\t$input\tLENGTH $len"

	    set s [format "%-${len}s\t|\t%-${len}s" $left $right]

	    puts stdout "keys:\t$s"

	    puts stdout "\ncycled keys:"
    }

    # string -> list
    set input_list [split $input ""]

    set count 0
    # iterate each letter
    foreach letter $input_list {

	    incr count
	
	    if {$mode eq "encrypt" } {
	        # encrypt

	        # rotate and permute
	        set wheels [rotate $left $right $letter]
	        lassign $wheels left right

	        # ciphered letter to output (left[0])
	        lappend out [string index $left 0]
	
	    } else {

	        # decrypt

	        # rotate and permute
	        set wheels [rotate $right $left $letter]
	        lassign $wheels right left

	        # deciphered letter to output (right[0])
	        lappend out [string index $right 0]
 	    }

	    # cycle the alphabets
	    set cycled  [cycle $left $right]
	    lassign $cycled left right
	
	    if {$verbose} { puts stderr "${count}\t${left}\t|\t${right}" }

	
    } ; # foreach letter

    # list -> string
    set out [join $out ""]

    return $out
}


# ============= main =================
if { [info script] eq $::argv0 } {

    # --------- init ------------------
    set left  $l_key
    set right $r_key
    set plain_text "WELLDONEISBETTERTHANWELLSAID"

    # ---------- encipher -------------

    set cipher_text [chao $plain_text $left $right encrypt 1]

    # ---------- decipher -------------

    set decrypted_text [chao $cipher_text $left $right decrypt 0]
    # ----------- output --------------

    puts stdout "\nplain text:  \t ${plain_text}"
    puts stdout "\ncipher text: \t ${cipher_text}"
    puts stdout "\ndecrypted:   \t ${decrypted_text}"

    return 0
}

# end
