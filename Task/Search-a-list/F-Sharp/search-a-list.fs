List.findIndex (fun x -> x = "bar") ["foo"; "bar"; "baz"; "bar"]  // -> 1
                                      // A System.Collections.Generic.KeyNotFoundException
                                      // is raised, if the predicate does not evaluate to
                                      // true for any list element.
