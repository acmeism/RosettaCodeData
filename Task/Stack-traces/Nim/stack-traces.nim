proc g() =
  # Writes the current stack trace to stderr.
  writeStackTrace()
  # Or fetch the stack trace entries for the current stack trace:
  echo "----"
  for e in getStackTraceEntries():
    echo e.filename, "@", e.line, " in ", e.procname

proc f() =
  g()

f()
