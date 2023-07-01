# Use inflect

"""

  show all eban numbers <= 1,000 (in a horizontal format), and a count
  show all eban numbers between 1,000 and 4,000 (inclusive), and a count
  show a count of all eban numbers up and including 10,000
  show a count of all eban numbers up and including 100,000
  show a count of all eban numbers up and including 1,000,000
  show a count of all eban numbers up and including 10,000,000

"""

import inflect
import time

before = time.perf_counter()

p = inflect.engine()

# eban numbers <= 1000

print(' ')
print('eban numbers up to and including 1000:')
print(' ')

count = 0

for i in range(1,1001):
    if not 'e' in p.number_to_words(i):
        print(str(i)+' ',end='')
        count += 1

print(' ')
print(' ')
print('count = '+str(count))
print(' ')

# eban numbers 1000 to 4000

print(' ')
print('eban numbers between 1000 and 4000 (inclusive):')
print(' ')

count = 0

for i in range(1000,4001):
    if not 'e' in p.number_to_words(i):
        print(str(i)+' ',end='')
        count += 1

print(' ')
print(' ')
print('count = '+str(count))
print(' ')

# eban numbers up to 10000

print(' ')
print('eban numbers up to and including 10000:')
print(' ')

count = 0

for i in range(1,10001):
    if not 'e' in p.number_to_words(i):
        count += 1

print(' ')
print('count = '+str(count))
print(' ')

# eban numbers up to 100000

print(' ')
print('eban numbers up to and including 100000:')
print(' ')

count = 0

for i in range(1,100001):
    if not 'e' in p.number_to_words(i):
        count += 1

print(' ')
print('count = '+str(count))
print(' ')

# eban numbers up to 1000000

print(' ')
print('eban numbers up to and including 1000000:')
print(' ')

count = 0

for i in range(1,1000001):
    if not 'e' in p.number_to_words(i):
        count += 1

print(' ')
print('count = '+str(count))
print(' ')

# eban numbers up to 10000000

print(' ')
print('eban numbers up to and including 10000000:')
print(' ')

count = 0

for i in range(1,10000001):
    if not 'e' in p.number_to_words(i):
        count += 1

print(' ')
print('count = '+str(count))
print(' ')

after = time.perf_counter()

print(" ")
print("Run time in seconds: "+str(after - before))
