from time import time
st = time()
stp = 9 * 8 * 7
for n in range((9876312 // stp) * stp, 0, -stp):
    s = str(n)
    if "0" in s or "5" in s or len(set(s)) < len(s): continue
    print("Base 10 =", n, "in %.3f" % (1e6 * (time() - st)), "μs");
    break;
st = time()
stp = 15 * 14 * 13 * 12 * 11
for n in range((0xfedcba976543218 // stp) * stp, 0, -stp):
    s = hex(n)[2:]
    if "0" in s or len(set(s)) < len(s): continue
    print("Base 16 =", hex(n), "in %.3f" % (1e3 * (time() - st)), end = "ms")
    break;
