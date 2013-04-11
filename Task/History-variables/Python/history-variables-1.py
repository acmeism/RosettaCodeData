import sys

HIST = {}

def trace(frame, event, arg):
    for name,val in frame.f_locals.items():
        if name not in HIST:
            HIST[name] = []
        else:
            if HIST[name][-1] is val:
                continue
        HIST[name].append(val)
    return trace

def undo(name):
    HIST[name].pop(-1)
    return HIST[name][-1]

def main():
    a = 10
    a = 20

    for i in range(5):
        c = i

    print "c:", c, "-> undo x3 ->",
    c = undo('c')
    c = undo('c')
    c = undo('c')
    print c
    print 'HIST:', HIST

sys.settrace(trace)
main()
