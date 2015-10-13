#!/usr/bin/env python3

HW = r'''
/++++!/===========?\>++.>+.+++++++..+++\
\+++\ | /+>+++++++>/ /++++++++++<<.++>./
$+++/ | \+++++++++>\ \+++++.>.+++.-----\
      \==-<<<<+>+++/ /=.>.+>.--------.-/'''

def snusp(store, code):
    ds = bytearray(store)  # data store
    dp = 0                 # data pointer
    cs = code.splitlines() # 2 dimensional code store
    ipr, ipc = 0, 0        # instruction pointers in row and column
    for r, row in enumerate(cs):
        try:
            ipc = row.index('$')
            ipr = r
            break
        except ValueError:
            pass
    rt, dn, lt, up = range(4)
    id = rt  # instruction direction.  starting direction is always rt
    def step():
        nonlocal ipr, ipc
        if id&1:
            ipr += 1 - (id&2)
        else:
            ipc += 1 - (id&2)
    while ipr >= 0 and ipr < len(cs) and ipc >= 0 and ipc < len(cs[ipr]):
        op = cs[ipr][ipc]
        if op == '>':
            dp += 1
        elif op == '<':
            dp -= 1
        elif op == '+':
            ds[dp] += 1
        elif op == '-':
            ds[dp] -= 1
        elif op == '.':
            print(chr(ds[dp]), end='')
        elif op == ',':
            ds[dp] = input()
        elif op == '/':
            id = ~id
        elif op == '\\':
            id ^= 1
        elif op == '!':
            step()
        elif op == '?':
            if not ds[dp]:
                step()
        step()

if __name__ == '__main__':
    snusp(5, HW)
