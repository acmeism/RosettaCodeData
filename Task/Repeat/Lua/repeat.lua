function myFunc ()
    print("Sure looks like a function in here...")
end

function rep (func, times)
    for count = 1, times do
        func()
    end
end

rep(myFunc, 4)
