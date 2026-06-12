""" https://rosettacode.org/wiki/Long_stairs """

from numpy import mean
from random import sample

def gen_long_stairs(start_step, start_length, climber_steps, add_steps):
    secs, behind, total = 0, start_step, start_length
    while True:
        behind += climber_steps
        behind += sum([behind > n for n in sample(range(total), add_steps)])
        total += add_steps
        secs += 1
        yield (secs, behind, total)


ls = gen_long_stairs(1, 100, 1, 5)

print("Seconds  Behind  Ahead\n----------------------")
while True:
    secs, pos, len = next(ls)
    if 600 <= secs < 610:
        print(secs, "     ", pos, "   ", len - pos)
    elif secs == 610:
        break

print("\nTen thousand trials to top:")
times, heights = [], []
for trial in range(10_000):
    trialstairs = gen_long_stairs(1, 100, 1, 5)
    while True:
        sec, step, height = next(trialstairs)
        if step >= height:
            times.append(sec)
            heights.append(height)
            break

print("Mean time:", mean(times), "secs. Mean height:", mean(heights))
