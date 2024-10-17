let () =
  print_endline (
    if Unix.isatty Unix.stdout
    then "Output goes to tty."
    else "Output doesn't go to tty."
  )
