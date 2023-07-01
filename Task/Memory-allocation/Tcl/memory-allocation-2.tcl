package require memalloc

set block [memalloc 1000]
puts "allocated $block at [memaddr $block]"
memset $block 42 79
someOtherCommand [memaddr $block]
puts "$block\[42\] is now [memget $block 42]"
memfree $block
