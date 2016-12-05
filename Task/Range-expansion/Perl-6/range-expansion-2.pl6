grammar RangeList {
    token TOP    { <term>* % ','    { make $<term>.map(*.made)       } }
    token term   { [<range>|<num>]  { make ($<num> // $<range>).made } }
    token range  { <num> '-' <num>  { make +$<num>[0] .. +$<num>[1]  } }
    token num    { '-'? \d+         { make +$/                       } }
}

say RangeList.parse('-6,-3--1,3-5,7-11,14,15,17-20').made.flat.join(', ');
