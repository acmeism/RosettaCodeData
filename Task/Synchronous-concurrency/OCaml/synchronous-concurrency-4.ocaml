let _ =
  let count = new_channel ()
  and lines = new_channel ()
  in
  let _ = Thread.create (printer lines) count
  in reader count lines
