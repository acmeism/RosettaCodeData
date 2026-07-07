from random import random, choice
from bisect import bisect
from collections import defaultdict

def probchoice(items, probs):
  '''\
  Splits the interval 0.0-1.0 in proportion to probs
  then finds where each random.random() choice lies
  '''

  prob_accumulator = 0
  accumulator = []
  for p in probs:
    prob_accumulator += p
    accumulator.append(prob_accumulator)

  while True:
    r = random()
    yield items[bisect(accumulator, r)]

def probchoice2(items, probs, bincount = 10000):
  '''\
  Puts items in bins in proportion to probs
  then uses random.choice() to select items.

  Larger bincount for more memory use but
  higher accuracy (on avarage).
  '''

  bins = []
  for item, prob in zip(items, probs):
    bins += [item] * int(bincount * prob)
  while True:
    yield choice(bins)


def tester(
    func = probchoice,
    items = 'good bad ugly'.split(),
    probs = [0.5, 0.3, 0.2],
    trials = 100000
):
  def problist2string(probs):
    '''\
    Turns a list of probabilities into a string
    Also rounds FP values
    '''
    return ", ".join('%8.6f' % (p,) for p in probs)

  counter = defaultdict(int)
  it = func(items, probs)
  for _ in range(trials):
    counter[next(it)] += 1
  print("\n##\n## %s\n##" % func.__name__.upper())
  print("Trials:              ", trials)
  print("Items:               ", ' '.join(items))
  print("Target probabilities:  ", problist2string(probs))
  print(
    "Attained probabilities:",
    problist2string(counter[x] / trials for x in items)
  )

if __name__ == '__main__':
  items = 'aleph beth gimel daleth he waw zayin heth'.split()
  probs = [1 / (n+5) for n in range(len(items))]
  probs[-1] = 1-sum(probs[:-1])
  tester(probchoice, items, probs, 1000000)
  tester(probchoice2, items, probs, 1000000)
