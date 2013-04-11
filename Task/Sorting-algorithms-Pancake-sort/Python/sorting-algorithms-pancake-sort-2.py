if __name__ == '__main__':
    import random

    tutor = True
    data = list('123456789')
    while data == sorted(data):
        random.shuffle(data)
    print('Original List: %r' % ' '.join(data))
    pancakesort(data)
    print('Pancake Sorted List: %r' % ' '.join(data))
