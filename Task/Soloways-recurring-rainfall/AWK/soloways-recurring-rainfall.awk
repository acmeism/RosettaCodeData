BEGIN {
  if (!sentinel) sentinel = 99999
  print("Enter the rainfall values (" sentinel " to quit):")
}

$0 == sentinel {
  exit
}

/^-?[0-9]+$/ {
  total += $1
  count++
  next
}

{
  print("Ignoring \"" $0 "\", please enter only integers.")
}

END {
  if (count > 0) {
    print("The average rainfall is", total / count)
  }
}
