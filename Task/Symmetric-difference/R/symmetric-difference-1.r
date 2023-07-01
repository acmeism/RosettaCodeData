a <- c( "John", "Bob", "Mary", "Serena" )
b <- c( "Jim", "Mary", "John", "Bob" )
c(setdiff(b, a), setdiff(a, b))

a <- c("John", "Serena", "Bob", "Mary", "Serena")
b <- c("Jim", "Mary", "John", "Jim", "Bob")
c(setdiff(b, a), setdiff(a, b))
