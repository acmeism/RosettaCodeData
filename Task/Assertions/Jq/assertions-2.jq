# File: example.jq
# This example assumes the availability of the $__loc__ function
# and that assert.jq is in the same directory as example.jq.

include "assert" {search: "."};

def test:
  "This is an input"
  | 0 as $x
  | assert($x == 42; $__loc__),
    asserteq($x; 42; $__loc__);

test
