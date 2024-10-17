fn generic_swap<'a, T>(var1: &'a mut T, var2: &'a mut T) {
    std::mem::swap(var1, var2)
}
