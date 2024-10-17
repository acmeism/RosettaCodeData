try
  while true do
    output_char stdout (input_char stdin)
  done
with End_of_file -> ()
