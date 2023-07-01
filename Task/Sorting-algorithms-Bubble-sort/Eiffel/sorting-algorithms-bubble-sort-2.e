class
    MY_SORTED_SET [G -> COMPARABLE]
inherit
    TWO_WAY_SORTED_SET [G]
        redefine
            sort
        end
create
    make

feature
    sort
            -- Sort with bubble sort
        local
            l_unchanged: BOOLEAN
            l_item_count: INTEGER
            l_temp: G
        do
            from
                l_item_count := count
            until
                l_unchanged
            loop
                l_unchanged := True
                l_item_count := l_item_count - 1
                across 1 |..| l_item_count as ic loop
                    if Current [ic.item] > Current [ic.item + 1] then
                        l_temp := Current [ic.item]
                        Current [ic.item] := Current [ic.item + 1]
                        Current [ic.item + 1] := l_temp
                        l_unchanged := False
                    end
                end
            end
        end
end
