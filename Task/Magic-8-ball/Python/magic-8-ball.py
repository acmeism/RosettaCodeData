import random

s = ('It is certain', 'It is decidedly so', 'Without a doubt', 'Yes, definitely',
 'You may rely on it', 'As I see it, yes', 'Most likely', 'Outlook good',
 'Signs point to yes', 'Yes', 'Reply hazy, try again', 'Ask again later',
 'Better not tell you now', 'Cannot predict now', 'Concentrate and ask again',
 "Don't bet on it", 'My reply is no', 'My sources say no', 'Outlook not so good',
 'Very doubtful')

q_and_a = {}

while True:
    question = input('Ask your question:')
    if len(question) == 0: break

    if question in q_and_a:
        print('Your question has already been answered')
    else:
        answer = random.choice(s)
        q_and_a[question] = answer
        print(answer)
