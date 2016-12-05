Delegator := Object clone do(
    delegate ::= nil
    operation := method(
        if((delegate != nil) and (delegate hasSlot("thing")),
            delegate thing,
            "default implementation"
        )
    )
)

Delegate := Object clone do(
    thing := method("delegate implementation")
)

a := clone Delegator
a operation println

a setDelegate("A delegate may be any object")
a operation println

a setDelegate(Delegate clone)
a operation println
