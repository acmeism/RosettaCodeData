# This example includes the extra credit.
# With a slight variation, a matching suffix can be identified.
# Note that suffixes with two or more dots (ie a dot in suffix) are checked for each case.
# This way, filename.1.txt will match for txt, and filename3.tar.gz.1 will match for tar.gz.1 for example.

# Example input data:
set f_list [list \
                "MyData.a##" \
                MyData.tar.Gz \
                MyData.gzip \
                MyData.7z.backup \
                "MyData..." \
                MyData \
                MyData_v1.0.tar.bz2 \
                MyData_v1.0.bz2 ]
set suffix_input_list [list zip rar 7z gz archive "A##" tar.bz2 ]

# Prefix a dot to any suffix that does not begin with a dot.
set suffix_list [list ]
foreach s $suffix_input_list {
    if { [string range $s 0 0] ne "." } {
        set s2 "."
    } else {
        set s2 ""
    }
    append s2 $s
    lappend suffix_list [string tolower $s2]
}

# Check each filename
foreach filename0 $f_list {
    set filename1 [string tolower [file tail $filename0]]
    set suffix1 [file extension $filename1]
    set file_suffix_list [list $suffix1]
    set filename2 [file rootname $filename1]
    set i 0
    # i is an infinite loop breaker. In case there is some unforseen case..
    while { $filename2 ne "" && $filename2 ne $filename1 && $i < 32} {
        # Another suffix is possible
        set suffix2 [file extension $filename2]
        if { $suffix2 ne "" } {
            # found another suffix
            append suffix2 $suffix1
            lappend file_suffix_list $suffix2
        }
        set suffix1 $suffix2
        set filename1 $filename2
        set filename2 [file rootname $filename2]
        incr i
    }
    set a_suffix_found_p 0
    foreach file_suffix $file_suffix_list {
        if { $file_suffix in $suffix_list } {
            set a_suffix_found_p 1
        }
    }
    puts -nonewline "${filename0}\t"
    if { $a_suffix_found_p } {
        puts "true"
    } else {
        puts "false"
    }
}
