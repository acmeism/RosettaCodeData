//Single param array:
array->sort

//An array of pairs, order by the right hand element of the pair:
with i in array order by #i->second do => { … }

//The array can also be ordered by multiple values:
with i in array order by #i->second, #i->first do => { … }
