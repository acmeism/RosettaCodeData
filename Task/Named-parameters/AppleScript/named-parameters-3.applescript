on getName(x) -- x assumed to be a record for this demo.
    set x to x & {firstName:"?", lastName:"?"}

    return x's firstName & ", " & x's lastName
end getName

getName({lastName:"Doe"})
--> "?, Doe"
