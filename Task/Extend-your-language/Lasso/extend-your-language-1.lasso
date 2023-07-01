// Create a type to handle the captures

define if2 => type {
    data private a, private b
    public oncreate(a,b) => {
        .a = #a
        .b = #b
        thread_var_push(.type,self)
        handle => { thread_var_pop(.type)}
        return givenblock()
    }
    public ifboth => .a && .b ? givenblock()
    public else1  => .a && !.b ? givenblock()
    public else2  => !.a && .b ? givenblock()
    public else => !.a && !.b ? givenblock()
}

// Define methods to consider givenblocks

define ifboth => thread_var_get(::if2)->ifboth => givenblock
define else1 => thread_var_get(::if2)->else1 => givenblock
define else2 => thread_var_get(::if2)->else2 => givenblock
define else => thread_var_get(::if2)->else => givenblock
