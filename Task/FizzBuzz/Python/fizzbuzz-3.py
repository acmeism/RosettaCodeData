for n in range(1,101):
    response = ''

    if not n%3:
        response += 'Fizz'
    if not n%5:
        response += 'Buzz'

    print(response or n)
