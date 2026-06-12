proc p*() =
  ## Some exported procedure.
  echo "Executing procedure"

# Some code to execute to initialize the module.
echo "Initializing the module"

when isMainModule:
  # Some code to execute if the module is run directly, for instance code to test the module.
  echo "Running tests"
