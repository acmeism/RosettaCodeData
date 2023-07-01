proc cellAutomata =
  proc evolveInto(x, t : var string) =
    for i in x.low..x.high:
      let
        alive = x[i] == 'o'
        left  = if i == x.low:  false else: x[i - 1] == 'o'
        right = if i == x.high: false else: x[i + 1] == 'o'
      t[i] =
        if alive: (if left xor right: 'o' else: '.')
        else:     (if left and right: 'o' else: '.')

  var
    x = ".ooo.oo.o.o.o.o..o.."
    t = x

  for i in 1..10:
    x.echo
    x.evolveInto t
    swap t, x

cellAutomata()
