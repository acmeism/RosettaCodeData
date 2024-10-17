include sort.e
include wildcard.e
include misc.e

function my_compare(sequence a, sequence b)
    if length(a)!=length(b) then
        return -compare(length(a),length(b))
    else
        return compare(lower(a),lower(b))
    end if
end function

sequence strings
strings = reverse({ "Here", "are", "some", "sample", "strings", "to", "be", "sorted" })

puts(1,"Unsorted:\n")
pretty_print(1,strings,{2})

puts(1,"\n\nSorted:\n")
pretty_print(1,custom_sort(routine_id("my_compare"),strings),{2})
