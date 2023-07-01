type HistoryVar[T] = object
  hist: seq[T]

func initHistoryVar[T](value: T = T.default): HistoryVar[T] =
  ## Initialize a history variable with given value.
  result.hist.add value

func set(h: var HistoryVar; value: h.T) =
  ## Set the history variable to given value.
  h.hist.add value

func get(h: HistoryVar): h.T =
  ## Return the current value of history variable.
  h.hist[^1]

proc showHistory(h: HistoryVar) =
  ## Show the history starting from oldest values.
  for i, value in h.hist:
    echo i, ": ", value

func pop(h: var HistoryVar): h.T =
  ## Pop the current value and return it.
  if h.hist.len > 1: h.hist.pop() else: h.hist[0]


when isMainModule:

  var h = initHistoryVar[int]()   # Initialized to 0.

  echo "Assigning three values: 1, 2, 3"
  h.set(1)      # 0, 1
  h.set(2)      # 0, 1, 2
  h.set(3)      # 0, 1, 2, 3

  echo "History (oldest values first):"
  h.showHistory()

  echo "Current value is ", h.get()

  echo "Recall the three values:"
  echo h.pop()  # -> 3, last value removed.
  echo h.pop()  # -> 2, last value removed.
  echo h.pop()  # -> 1, last value removed.

  echo "History (note that initial value can never be removed):"
  h.showHistory()
