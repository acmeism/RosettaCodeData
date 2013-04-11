(let (items)
  (gc) ; name varies by implementation
  (room)
  (dotimes (x 512)
    (push (allocate-something-of-interest) items))
  (gc)
  (room))
