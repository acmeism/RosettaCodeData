def tail = { list, n ->  def m = list.size(); list.subList([m - n, 0].max(),m) }

final STACK = [A:[],B:[],C:[]].asImmutable()

def report = { it -> }
def check = { it -> }

def moveRing = { from, to ->  to << from.pop(); report(); check(to) }

def moveStack
moveStack = { from, to, using = STACK.values().find { !(it.is(from) || it.is(to)) } ->
    if (!from) return
    def n = from.size()
    moveStack(tail(from, n-1), using, to)
    moveRing(from, to)
    moveStack(tail(using, n-1), to, from)
}
