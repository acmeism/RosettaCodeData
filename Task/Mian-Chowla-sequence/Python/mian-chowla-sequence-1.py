from itertools import count, islice, chain
import time

def mian_chowla():
    mc = [1]
    yield mc[-1]
    psums = set([2])
    newsums = set([])
    for trial in count(2):
        for n in chain(mc, [trial]):
            sum = n + trial
            if sum in psums:
                newsums.clear()
                break
            newsums.add(sum)
        else:
            psums |= newsums
            newsums.clear()
            mc.append(trial)
            yield trial

def pretty(p, t, s, f):
    print(p, t, " ".join(str(n) for n in (islice(mian_chowla(), s, f))))

if __name__ == '__main__':
    st = time.time()
    ts = "of the Mian-Chowla sequence are:\n"
    pretty("The first 30 terms", ts, 0, 30)
    pretty("\nTerms 91 to 100", ts, 90, 100)
    print("\nComputation time was", (time.time()-st) * 1000, "ms")
