def plural(word, amount): # Correctly pluralize a word.
    if amount == 1:
        return word
    else:
        return word + 's'

def sing(b, end): # Sing a phrase of the song, for b bottles, ending in end
    print b or 'No more', plural('bottle', b), end

for i in range(99, 0, -1):
    sing(i, 'of beer on the wall,')
    sing(i, 'of beer,')
    print 'Take one down, pass it around,'
    sing(i-1, 'of beer on the wall.\n')
