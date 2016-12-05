# An empty queue:
def fifo: [];

def push(e): [e] + .;

def pop: [.[0], .[1:]];

def pop_or_error: if length == 0 then error("pop_or_error") else pop end;

def empty: length == 0;
