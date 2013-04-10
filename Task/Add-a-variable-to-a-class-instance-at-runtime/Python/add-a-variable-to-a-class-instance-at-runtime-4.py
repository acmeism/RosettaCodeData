class empty(object):
    def __init__(this):
        this.foo = "whatever"

def patch_empty(obj):
    def fn(self=obj):
        print self.foo
    obj.print_output = fn

e = empty()
patch_empty(e)
e.print_output()
# >>> whatever
