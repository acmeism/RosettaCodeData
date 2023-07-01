on flatten(theList)
    script o
        property flatList : {}

        -- Recursive handler dealing with the current (sub)list.
        on flttn(thisList)
            script p
                property l : thisList
            end script

            repeat with i from 1 to (count thisList)
                set thisItem to item i of p's l
                if (thisItem's class is list) then
                    flttn(thisItem)
                else
                    set end of my flatList to thisItem
                end if
            end repeat
        end flttn
    end script

    if (theList's class is not list) then return theList
    o's flttn(theList)

    return o's flatList
end flatten
