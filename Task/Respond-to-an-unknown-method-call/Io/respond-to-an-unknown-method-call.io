Example := Object clone do(
    foo := method(writeln("this is foo"))
    bar := method(writeln("this is bar"))
    forward := method(
        writeln("tried to handle unknown method ",call message name)
        if( call hasArgs,
            writeln("it had arguments: ",call evalArgs)
        )
    )
)

example := Example clone

example foo          // prints "this is foo"
example bar          // prints "this is bar"
example grill        // prints "tried to handle unknown method grill"
example ding("dong") // prints "tried to handle unknown method ding"
                     // prints "it had arguments: list("dong")"
