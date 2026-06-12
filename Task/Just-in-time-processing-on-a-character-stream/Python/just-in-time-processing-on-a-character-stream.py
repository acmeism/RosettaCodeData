import sys

class UserInput:
    def __init__(self,chunk):
        self.formFeed = int(chunk[0])
        self.lineFeed = int(chunk[1])
        self.tab = int(chunk[2])
        self.space = int(chunk[3])

    def __str__(self):
        return "(ff=%d; lf=%d; tb=%d; sp%d)" % (self.formFeed,self.lineFeed,self.tab,self.space)

def chunks(l,n):
    for i in xrange(0, len(l), n):
        yield l[i:i+n]

def getUserInput():
    h = "0 18 0 0 0 68 0 1 0 100 0 32 0 114 0 45 0 38 0 26 0 16 0 21 0 17 0 59 0 11 "\
        "0 29 0 102 0 0 0 10 0 50 0 39 0 42 0 33 0 50 0 46 0 54 0 76 0 47 0 84 2 28"
    ha = h.split()
    return [UserInput(chunk) for chunk in chunks(ha, 4)]

def decode(filename,uiList):
    f = open(filename, "r")
    text = f.read()

    def decode2(ui):
        f = 0
        l = 0
        t = 0
        s = 0
        for c in text:
            if f == ui.formFeed and l == ui.lineFeed and t == ui.tab and s == ui.space:
                if c == '!':
                    return False
                sys.stdout.write(c)
                return True
            if c == '\u000c':
                f=f+1
                l=0
                t=0
                s=0
            elif c == '\n':
                l=l+1
                t=0
                s=0
            elif c == '\t':
                t=t+1
                s=0
            else:
                s=s+1
        return False

    for ui in uiList:
        if not decode2(ui):
            break
    print

##### Main #####

uiList = getUserInput()
decode("theRaven.txt", uiList)
