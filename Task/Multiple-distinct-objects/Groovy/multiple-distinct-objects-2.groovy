// Following fails, creates n references to same object
def createFoos2 = {n -> [new Foo()] * n }
