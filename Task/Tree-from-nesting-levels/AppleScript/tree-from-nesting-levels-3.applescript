on treeFromNestingLevels(input)
    script recursion
        property emptyList : {}

        on recurse(input, currentLevel)
            set output to {}
            set subnest to {}
            repeat with thisLevel in input
                set thisLevel to thisLevel's contents
                if (thisLevel > currentLevel) then
                    set end of subnest to thisLevel
                else
                    if (subnest ≠ emptyList) then
                        set end of output to recurse(subnest, currentLevel + 1)
                        set subnest to {}
                    end if
                    set end of output to thisLevel
                end if
            end repeat
            if (subnest ≠ emptyList) then set end of output to recurse(subnest, currentLevel + 1)

            return output
        end recurse
    end script

    return recursion's recurse(input, 1)
end treeFromNestingLevels
