""" Get all words in the file unixdict.txt between 4 and 9 letters in length """
function getwordsfromfile(filename::String, minlength::Int = 4, maxlength::Int = 9)
    filter(w -> !contains(w, "'") && minlength <= length(w) <= maxlength, strip.(readlines(filename)))
end
const UNIXDICT_WORDS = getwordsfromfile("unixdict.txt")


"""
Make a program that generates a passphrase with n words.
Rules:
- Every word must start with an uppercase letter,
- Every word should have a number after their last letter, and,
- Every word, excapt the last one, should have a separator (-)
Example:
For n = 5, the output might look like this: Hello92-Butterfly89-Elephant55-Rainbow44-Sunshine38
"""
function generatepassphrase(wordsperphrase::Int)
    join(map(w -> uppercasefirst(w) * string(rand(10:99)), rand(UNIXDICT_WORDS, wordsperphrase)), "-")
end

for _ in 1:4
    println(generatepassphrase(5))
end
