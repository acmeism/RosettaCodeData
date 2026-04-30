# print formatted output
proc print_array {fields arr}  {
    # list back to array
    array set A  $arr
    set names [array names A]

    foreach key $fields {
	# format output
	    puts -nonewline stdout [format "%-10s" $key]	
	    if {$key in $names} {
	        puts stdout [format "%-16s" $A($key)]
	    } else {
	        puts stdout ""
	    }
    }
}

# set field order
set fields [list name price color year]
puts "skates"
print_array $fields [array get skates]


# list of updates {arrayname item value}
set updates {
    {skates price 15.15}
    {skates color red}
    {skates year 1974}
    }

# update array
foreach update $updates {
    lassign $update item field value
    array set $item [list $field $value]
}

puts [string repeat "-" 24]
puts "skates updated"
print_array $fields [array get skates]
