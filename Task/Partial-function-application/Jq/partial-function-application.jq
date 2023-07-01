# fs(f, s) takes a function, f, of one value and a sequence of values s,
# and returns an ordered sequence of the result of applying function f to every value of s in turn.

def fs(f; s): s | f;

# f1 takes a value and returns it multiplied by 2:
def f1: 2 * .;

# f2 takes a value and returns it squared:
def f2: . * .;

# Partially apply f1 to fs to form function fsf1(s):
def fsf1(s): fs(f1;s);

# Partially apply f2 to fs to form function fsf2(s)
def fsf2(s): fs(f2; s);

# Test fsf1 and fsf2 by evaluating them with s being the sequence of integers from 0 to 3 inclusive ...

"fsf1",
[fsf1(range(0;4))],
"fsf2",
[fsf2(range(0;4))],

# and then the sequence of even integers from 2 to 8 inclusive:

"fsf1",
[fsf1(range(2;9;2))],
"fsf2",
[fsf2(range(2;9;2))]
