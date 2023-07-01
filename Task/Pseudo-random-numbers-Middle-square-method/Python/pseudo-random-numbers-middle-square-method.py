seed = 675248
def random():
    global seed
    seed = int(str(seed ** 2).zfill(12)[3:9])
    return seed
for _ in range(5):
    print(random())
