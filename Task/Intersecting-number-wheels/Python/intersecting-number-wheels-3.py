def nextfromr(w, name):
    nxt, w[name] = w[name][0], w[name][1:] + w[name][:1]
    return nxt if '0' <= nxt[0] <= '9' else nextfromr(w, nxt)

if __name__ == '__main__':
    for group in [{'A': '123'},
                  {'A': '1B2', 'B': '34'},
                  {'A': '1DD', 'D': '678'},
                  {'A': '1BC', 'B': '34', 'C': '5B'},]:
        print(f"Intersecting Number Wheel group:\n  {group}")
        first = next(group.__iter__())
        gen = ' '.join(nextfromr(group, first) for i in range(20))
        print(f"  Generates:\n   {gen} ...\n")
