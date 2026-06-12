set vocabula {amāre vidēre ducere audire}

array set coniugationes {
 a 0
 ā 0
 ē 1
 e 2
 i 3
 ī 3
}
set suffices {
 {ō ās at āmus ātis ant}
 {eō ēs et ēmus ētis ent}
 {ō is it imus itis unt}
 {iō īs it īmus ītis iunt}
}

foreach verbum $vocabula {
 regexp {(.*)(.)re$} $verbum _ radix coniugatio
 puts "Coniugatio verbi $verbum:"
 foreach suffix [lindex $suffices $coniugationes($coniugatio)] {
  puts $radix$suffix
 }
}
