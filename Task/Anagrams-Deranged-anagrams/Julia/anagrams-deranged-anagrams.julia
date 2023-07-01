using Base.isless
# Let's define the less than operator for any two vectors that have the same type:
# This does lexicographic comparison, we use it on vectors of chars in this task.
function Base.isless(t1, t2)
    for (a, b) in zip(t1, t2) # zip only to the shorter length
        if !isequal(a, b)
            return isless(a, b)
        end
    end
    return length(t1) < length(t2)
end

# The sort function of Julia doesn't work on strings, so we write one:
# This returns a sorted vector of the chars of the given string
sortchars(s::AbstractString) = sort(collect(Char, s))

# Custom comparator function for sorting the loaded wordlist
sortanagr(s1::AbstractString, s2::AbstractString) =
    if length(s1) != length(s2) length(s1) < length(s2) else sortchars(s1) < sortchars(s2) end

# Tests if two strings are deranged anagrams, returns a bool:
# in our case s2 is never longer than s1
function deranged(s1::AbstractString, s2::AbstractString)
    # Tests for derangement first
    for (a, b) in zip(s1, s2)
        if a == b return false end
    end
    # s1 and s2 are deranged, but are they anagrams at all?
    return sortchars(s1) == sortchars(s2)
end

# Task starts here, we load the wordlist line by line, strip eol char, and sort the wordlist
# in a way that ensures that longer words come first and anagrams go next to each other
words = sort(open(readlines, "./data/unixdict.txt"), rev = true, lt = sortanagr)

# Now we just look for deranged anagrams in the neighbouring words of the sorted wordlist
for i in 1:length(words)-1
    if deranged(words[i], words[i+1])
        # The first match is guaranteed to be the longest due to the custom sorting
        println("The longest deranged anagrams are $(words[i]) and $(words[i+1])")
        break
    end
end
