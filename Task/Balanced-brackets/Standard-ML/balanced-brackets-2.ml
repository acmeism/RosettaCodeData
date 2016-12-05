val () =
    List.app print
        (List.map
            (* Turn `true' and `false' to `OK' and `NOT OK' respectively *)
            (fn s => if isBalanced s
                then s ^ "\t\tOK\n"
                else s ^ "\t\tNOT OK\n"
            )
            (* A set of strings to test *)
            ["", "[]", "[][]", "[[][]]", "][", "][][", "[]][[]"]
        )
