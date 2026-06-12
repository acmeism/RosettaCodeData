import random, sys

def makerule(data, context):
    '''Make a rule dict for given data.'''
    rule = {}
    words = data.split(' ')
    index = context

    for word in words[index:]:
        key = ' '.join(words[index-context:index])
        if key in rule:
            rule[key].append(word)
        else:
            rule[key] = [word]
        index += 1

    return rule


def makestring(rule, length):
    '''Use a given rule to make a string.'''
    oldwords = random.choice(list(rule.keys())).split(' ') #random starting words
    string = ' '.join(oldwords) + ' '

    for i in range(length):
        try:
            key = ' '.join(oldwords)
            newword = random.choice(rule[key])
            string += newword + ' '

            for word in range(len(oldwords)):
                oldwords[word] = oldwords[(word + 1) % len(oldwords)]
            oldwords[-1] = newword

        except KeyError:
            return string
    return string


if __name__ == '__main__':
    with open(sys.argv[1], encoding='utf8') as f:
        data = f.read()
    rule = makerule(data, int(sys.argv[2]))
    string = makestring(rule, int(sys.argv[3]))
    print(string)
