def busy_beaver(beavers):
  tape = dict()
  pos = beaver = steps = 0

  while True:
    steps += 1
    value = tape.get(pos, 0)
    new_value, direction, next_beaver = beavers[beaver * 2 + value]
    tape[pos] = int(new_value)
    if next_beaver == 'H': return steps, sum(tape.values())
    pos += 1 if direction == 'R' else -1
    beaver = ord(next_beaver) - 65


rules = ['1RH not_used',
         '1RB 1LB 1LA 1RH',
         '1RB 1RH 0RC 1RB 1LC 1LA',
         '1RB 1LB 1LA 0LC 1RH 1LD 1RD 0RA',
         '1RB 1LC 1RC 1RB 1RD 0LE 1LA 1LD 1RH 0LA']

for beavers in rules:
  beavers = beavers.split()
  steps, ones = busy_beaver(beavers)
  print(f'BB({len(beavers)//2}) = {steps:>10,} steps with {ones:>5,} ones')
