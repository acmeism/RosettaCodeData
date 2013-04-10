$array = array();
$array['foo'] = 'bar';
$array['bar'] = 'foo';

echo($array['foo']); // bar
echo($array['moo']); // Undefined index

//alternative (inline) way
$array2 = array('fruit' => 'apple',
                'price' => 12.96,
                'colour' => 'green');
