makeList := method(separator,
    counter := 1
    makeItem := method(item,
        result := counter .. separator .. item .. "\n"
        counter = counter + 1
        result
    )
    makeItem("first") .. makeItem("second") .. makeItem("third")
)
makeList(". ") print
