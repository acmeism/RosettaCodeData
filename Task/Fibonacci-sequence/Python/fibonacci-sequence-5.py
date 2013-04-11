def fibGen():
    f0, f1 = 0, 1
    while True:
        yield f0
        f0, f1 = f1, f0+f1
