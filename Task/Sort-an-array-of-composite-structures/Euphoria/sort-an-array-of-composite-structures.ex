include sort.e
include misc.e

constant NAME = 1
function compare_names(sequence a, sequence b)
    return compare(a[NAME],b[NAME])
end function

sequence s
s = { { "grass",  "green" },
      { "snow",   "white" },
      { "sky",    "blue"  },
      { "cherry", "red"   } }

pretty_print(1,custom_sort(routine_id("compare_names"),s),{2})
