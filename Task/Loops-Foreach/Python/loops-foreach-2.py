lines = words = characters = 0
f = open('somefile','r')
for eachline in f:
    lines += 1
    for eachword in eachline.split():
        words += 1
        for eachchar in eachword:
            chracters += 1

print lines, words, characters
