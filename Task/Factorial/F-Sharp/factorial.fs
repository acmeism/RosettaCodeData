//val inline factorial :
//   ^a ->  ^a
//    when  ^a : (static member get_One : ->  ^a) and
//          ^a : (static member ( + ) :  ^a *  ^a ->  ^a) and
//          ^a : (static member ( * ) :  ^a *  ^a ->  ^a)
let inline factorial n = Seq.reduce (*) [ LanguagePrimitives.GenericOne .. n ]
