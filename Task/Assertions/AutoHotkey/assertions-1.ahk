a := 42
Assert(a > 10)
Assert(a < 42) ; throws exception

Assert(bool){
    If !bool
        throw Exception("Expression false", -1)
}
