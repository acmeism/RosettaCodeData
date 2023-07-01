function makeList (separator)
    local counter = 0
    local function makeItem(item)
            counter = counter + 1
            return counter .. separator .. item .. "\n"
        end
    return makeItem("first") .. makeItem("second") .. makeItem("third")
end

print(makeList(". "))
