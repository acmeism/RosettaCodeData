def makeList(separator):
    counter = 1

    def makeItem(item):
        nonlocal counter
        result = str(counter) + separator + item + "\n"
        counter += 1
        return result

    return makeItem("first") + makeItem("second") + makeItem("third")

print(makeList(". "))
