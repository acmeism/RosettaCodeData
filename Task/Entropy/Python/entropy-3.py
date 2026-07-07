from math import log2

def entropy(text):
    exr = {}
    infoc = 0
    for each in text:
        try:
            exr[each] += 1
        except:
            exr[each] = 1
    textlen = len(text)
    for _, v in exr.items():
        freq  =  v / textlen
        infoc += freq * log2(freq)
    infoc *= -1
    return infoc

while True:
    text = input("Enter a string (or q to quit): ")
    if text == "q":
        break
    print(entropy(text))
