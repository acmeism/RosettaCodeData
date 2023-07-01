# records is a list of dicts.
set records {
  { name "Lagos"                population 21.0  }
  { name "Cairo"                population 15.2  }
  { name "Kinshasa-Brazzaville" population 11.3  }
  { name "Greater Johannesburg" population  7.55 }
  { name "Mogadishu"            population  5.85 }
  { name "Khartoum-Omdurman"    population  4.98 }
  { name "Dar Es Salaam"        population  4.7  }
  { name "Alexandria"           population  4.58 }
  { name "Abidjan"              population  4.4  }
  { name "Casablanca"           population  3.98 }
}

# Tcl's version of "higher order programming" is a bit unusual.  Instead of passing lambda
# functions, it is often easier to pass script fragments.  This command takes two such
# arguments: $test is an expression (as understood by [expr]), and $action is a script.
# thanks to [dict with], both $test and $action can refer to the fields of the current
# record by name - or to other variables used in the proc, like $index or $record.
proc search {records test action} {
    set index 0
    foreach record $records {
        dict with record {}
        if $test $action
        incr index
    }
    error "No match found!"
}

#  Find the (zero-based) index of the first city in the list whose name is "Dar Es Salaam"
puts [search $records {$name eq "Dar Es Salaam"} {return $index}]
#  Find the name of the first city in this list whose population is less than 5 million
puts [search $records {$population < 5.0} {return $name}]
#  Find the population of the first city in this list whose name starts with the letter "A"
puts [search $records {[string match A* $name]} {return $population}]
