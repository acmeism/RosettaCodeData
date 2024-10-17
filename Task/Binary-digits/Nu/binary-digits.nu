def bin [x] { $x | (fmt).binary | str substring 2.. }

[0 1 2 5 50 9000] | each { {dec: $in bin: (bin $in)} }
