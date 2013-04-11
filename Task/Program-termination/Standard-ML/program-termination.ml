if problem then
  OS.Process.exit OS.Process.failure
  (* valid status codes include OS.Process.success and OS.Process.failure *)
else
  ()
