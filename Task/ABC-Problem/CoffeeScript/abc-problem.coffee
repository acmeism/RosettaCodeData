canMakeWord = (word="") ->
    # Create a shallow clone of the master blockList
    blocks = blockList.slice 0
    # Check if blocks contains letter
    checkBlocks = (letter) ->
        # Loop through every remaining block
        for block, idx in blocks
            # If letter is in block, blocks.splice will return an array, which will evaluate as true
            return blocks.splice idx, 1 if letter.toUpperCase() in block
        return false
    # Return true if there are no falsy values
    return false not in (checkBlocks letter for letter in word)

# Expect true, true, false, true, false, true, true, true
console.log (canMakeWord word for word in ["A", "BARK", "BOOK", "TREAT", "COMMON", "squad", "CONFUSE", "STORM"])
