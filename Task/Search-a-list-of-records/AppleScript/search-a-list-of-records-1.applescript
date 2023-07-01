-- RECORDS

property lstCities : [¬
    {|name|:"Lagos", population:21.0}, ¬
    {|name|:"Cairo", population:15.2}, ¬
    {|name|:"Kinshasa-Brazzaville", population:11.3}, ¬
    {|name|:"Greater Johannesburg", population:7.55}, ¬
    {|name|:"Mogadishu", population:5.85}, ¬
    {|name|:"Khartoum-Omdurman", population:4.98}, ¬
    {|name|:"Dar Es Salaam", population:4.7}, ¬
    {|name|:"Alexandria", population:4.58}, ¬
    {|name|:"Abidjan", population:4.4}, ¬
    {|name|:"Casablanca", population:3.98}]


-- SEARCHES

-- nameIsDar :: Record -> Bool
on nameIsDar(rec)
    |name| of rec = "Dar Es Salaam"
end nameIsDar

-- popBelow :: Record -> Bool
on popBelow5M(rec)
    population of rec < 5
end popBelow5M

-- nameBeginsWith :: Record -> Bool
on nameBeginsWithA(rec)
    text 1 of |name| of rec = "A"
end nameBeginsWithA


-- TEST
on run

    return {¬
        findIndex(nameIsDar, lstCities), ¬
        ¬
            |name| of find(popBelow5M, lstCities), ¬
        ¬
            population of find(nameBeginsWithA, lstCities)}

end run




-- GENERIC FUNCTIONS

-- find :: (a -> Bool) -> [a] -> Maybe a
on find(f, xs)
    tell mReturn(f)
        set lng to length of xs
        repeat with i from 1 to lng
            if lambda(item i of xs) then return item i of xs
        end repeat
        return missing value
    end tell
end find

-- findIndex :: (a -> Bool) -> [a] -> Maybe Int
on findIndex(f, xs)
    tell mReturn(f)
        set lng to length of xs
        repeat with i from 1 to lng
            if lambda(item i of xs) then return i
        end repeat
        return missing value
    end tell
end findIndex

-- Lift 2nd class handler function into 1st class script wrapper
-- mReturn :: Handler -> Script
on mReturn(f)
    if class of f is script then
        f
    else
        script
            property lambda : f
        end script
    end if
end mReturn
