func Y<In, Out>( f: (In->Out) -> (In->Out) ) -> (In->Out) {
    return { x in f(Y(f))(x) }
}
