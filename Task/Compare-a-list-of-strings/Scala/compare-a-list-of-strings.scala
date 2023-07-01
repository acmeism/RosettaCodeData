def strings_are_equal(seq:List[String]):Boolean = seq match {
    case Nil => true
    case s::Nil => true
    case el1 :: el2 :: tail => el1==el2 && strings_are_equal(el2::tail)
}

def asc_strings(seq:List[String]):Boolean = seq match {
    case Nil => true
    case s::Nil => true
    case el1 :: el2 :: tail => el1.compareTo(el2) < 0
}
