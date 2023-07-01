myMethodComputingFib:arg
    |_|

    ^ (_ := [:n | n <= 1
                    ifTrue:[n]
                    ifFalse:[(_ value:(n - 1))+(_ value:(n - 2))]]
      ) value:arg.
