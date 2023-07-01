# using => key does not need to be quoted unless it contains special chars
my %hash = (
  key1 => 'val1',
  'key-2' => 2,
  three => -238.83,
  4 => 'val3',
);

# using , both key and value need to be quoted if containing something non-numeric in nature
my %hash = (
  'key1', 'val1',
  'key-2', 2,
  'three', -238.83,
  4, 'val3',
);
