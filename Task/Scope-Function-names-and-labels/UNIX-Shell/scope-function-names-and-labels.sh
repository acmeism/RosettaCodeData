#!/bin/sh
multiply 3 4    # This will not work
echo $?    # A bogus value was returned because multiply definition has not yet been run.

multiply() {
  return `expr $1 \* $2`    # The backslash is required to suppress interpolation
}

multiply 3 4    # Ok. It works now.
echo $?         # This gives 12
