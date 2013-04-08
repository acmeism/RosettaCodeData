ones = (
'', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'
)
prefixes = ('thir', 'four', 'fif', 'six', 'seven', 'eigh', 'nine')
tens = ['', '', 'twenty' ]
teens = ['ten', 'eleven', 'twelve']
for prefix in prefixes:
    tens.append(prefix + 'ty')
    teens.append(prefix +'teen')
tens[4] = 'forty'

def number(num):
    "get the wordy version of a number"
    ten, one = divmod(num, 10)
    if ten == 0 and one == 0:
        return 'no'
    elif ten == 0:
        return ones[one]
    elif ten == 1:
        return teens[one]
    elif one == 0:
        return tens[ten]
    else:
        return "%s-%s" % (tens[ten], ones[one])

def bottles(beer):
    "our rephrase"
    return "%s bottle%s of beer" % (
            number(beer).capitalize(), 's' if beer > 1 else ''
    )

onthewall = 'on the wall'
takeonedown = 'Take one down, pass it around'
for beer in range(99, 0, -1):
    print bottles(beer), onthewall
    print bottles(beer)
    print takeonedown
    print bottles(beer-1), onthewall
    print
