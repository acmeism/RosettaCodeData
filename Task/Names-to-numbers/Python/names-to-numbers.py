from spell_integer import spell_integer, SMALL, TENS, HUGE

def int_from_words(num):
    words = num.replace(',','').replace(' and ', ' ').replace('-', ' ').split()
    if words[0] == 'minus':
        negmult = -1
        words.pop(0)
    else:
        negmult = 1
    small, total = 0, 0
    for word in words:
        if word in SMALL:
            small += SMALL.index(word)
        elif word in TENS:
            small += TENS.index(word) * 10
        elif word == 'hundred':
            small *= 100
        elif word == 'thousand':
            total += small * 1000
            small = 0
        elif word in HUGE:
            total += small * 1000 ** HUGE.index(word)
            small = 0
        else:
            raise ValueError("Don't understand %r part of %r" % (word, num))
    return negmult * (total + small)


if __name__ == '__main__':
    # examples
    for n in range(-10000, 10000, 17):
        assert n == int_from_words(spell_integer(n))

    for n in range(20):
        assert 13**n == int_from_words(spell_integer(13**n))

    print('\n##\n## These tests show <==> for a successful round trip, otherwise <??>\n##\n')
    for n in (0, -3, 5, -7, 11, -13, 17, -19, 23, -29):
        txt = spell_integer(n)
        num = int_from_words(txt)
        print('%+4i <%s> %s' % (n, '==' if n == num else '??', txt))
    print('')

    n = 201021002001
    while n:
        txt = spell_integer(n)
        num = int_from_words(txt)
        print('%12i <%s> %s' % (n, '==' if n == num else '??', txt))
        n //= -10
    txt = spell_integer(n)
    num = int_from_words(txt)
    print('%12i <%s> %s' % (n, '==' if n == num else '??', txt))
    print('')
