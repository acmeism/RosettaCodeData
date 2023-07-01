def spiral(size) {
  def array := makeFlex2DArray(size, size)
  var i := -1                   # Counter of numbers to fill
  var p := makeVector2(0, 0)    # "Position"
  var dp := makeVector2(1, 0)   # "Velocity"

  # If the cell we were to fill next (even after turning) is full, we're done.
  while (array[p.y(), p.x()] == null) {

    array[p.y(), p.x()] := (i += 1) # Fill cell
    def next := p + dp              # Look forward

    # If the cell we were to fill next is already full, then turn clockwise.
    # Gimmick: If we hit the edges of the array, by the modulo we wrap around
    # and see the already-filled cell on the opposite edge.
    if (array[next.y() %% size, next.x() %% size] != null) {
      dp := dp.clockwise()
    }

    # Move forward
    p += dp
  }

  return array
}
