/* Added by @1x24. Translated from C++. Uses the PHP 7.x spaceship operator */
$data = [
			[
				'name'=>'beef',
				'weight'=>3.8,
				'cost'=>36,
			],
			[
				'name'=>'pork',
				'weight'=>5.4,
				'cost'=>43,
			],
			[
				'name'=>'ham',
				'weight'=>3.6,
				'cost'=>90,
			],
			[
				'name'=>'greaves',
				'weight'=>2.4,
				'cost'=>45,
			],
			[
				'name'=>'flitch',
				'weight'=>4.0,
				'cost'=>30,
			],
			[
				'name'=>'brawn',
				'weight'=>2.5,
				'cost'=>56,
			],
			[
				'name'=>'welt',
				'weight'=>3.7,
				'cost'=>67,
			],
			[
				'name'=>'salami',
				'weight'=>3.0,
				'cost'=>95,
			],
			[
				'name'=>'sausage',
				'weight'=>5.9,
				'cost'=>98,
			],
		];

uasort($data, function($a, $b) {
    return ($b['cost']/$b['weight']) <=> ($a['cost']/$a['weight']);
});

$limit = 15;

foreach ($data as $item):
	if ($limit >= $item['weight']):
		echo "Take all the {$item['name']}<br/>";
	else:
		echo "Take $limit kg of {$item['name']}<br/>";
		break;
	endif;
	$limit -= $item['weight'];
endforeach;
