import sys
import inspect

def get_func_lineno(func: callable):
    return inspect.getsourcelines(func)[1]

def goto(label: callable):
    lineno = get_func_lineno(label)
    caller_frame = inspect.currentframe().f_back
    def trace(frame, event, arg):
        if frame == caller_frame and event == 'line':
            frame.f_lineno = lineno
            frame.f_trace = None
            sys.settrace(None)

        return trace

    caller_frame.f_trace = trace
    sys.settrace(trace)

c = 0
def l1(): ... # We can simulate labels using functions

if c < 5:
    print("< 5", c)
    c += 1
    goto(l1)
    pass # Dummy lines are needed for jumps to work
else:
    print("Goto ended")
    print("== 5", c)
