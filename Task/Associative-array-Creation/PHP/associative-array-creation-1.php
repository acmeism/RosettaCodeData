$array = array();
$array = []; // Simpler form of array initialization
$array['foo'] = 'bar';
$array['bar'] = 'foo';

echo($array['foo']); // bar
echo($array['moo']); // Undefined index

// Alternative (inline) way
$array2 = array('fruit' => 'apple',
                'price' => 12.96,
                'colour' => 'green');

// Another alternative (simpler) way
$array2 = ['fruit' => 'apple',
                'price' => 12.96,
                'colour' => 'green'];

// Check if key exists in the associative array
echo(isset($array['foo'])); // Faster, but returns false if the value of the element is set to null
echo(array_key_exists('foo', $array)); // Slower, but returns true if the value of the element is null
