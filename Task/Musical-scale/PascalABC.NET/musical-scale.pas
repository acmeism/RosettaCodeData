##
foreach var note in [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88, 523.25] do
  Console.Beep(note.Round, 500)
