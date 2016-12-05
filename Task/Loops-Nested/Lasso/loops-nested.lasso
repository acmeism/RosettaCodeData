local(a) = array(
    array(2, 12, 10, 4),
    array(18, 11, 9, 3),
    array(14, 15, 7, 17),
    array(6, 19, 8, 13),
    array(1, 20, 16, 5)
)

// Query expression
with i in delve(#a) do {
    stdoutnl(#i)
    #i == 20 ? return
}

// Nested loops
#a->foreach => {
    #1->foreach => {
        stdoutnl(#1)
        #1 == 20 ? return
    }
}
