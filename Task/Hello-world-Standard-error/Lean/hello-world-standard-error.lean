def main : IO Unit := do
  let stderr ← IO.getStderr
  stderr.putStrLn s!"Goodbye, World!"
