def permutations(xs):
    ac = [[]]
    for x in xs:
        ac_new = []
        for ts in ac:
            for n in range(0,ts.__len__()+1):
                new_ts = ts[:]  #(shallow) copy of ts
                new_ts.insert(n,x)
                ac_new.append(new_ts)
        ac=ac_new
    return ac

print(permutations([1,2,3,4]))
