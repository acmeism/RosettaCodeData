print $hashref->{key1};

$hashref->{key1} = 'val1';

@{$hashref}{('key1', 'three')} = ('val1', -238.83);
