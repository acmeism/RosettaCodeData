<?php

$data_array = [
  ['name' => 'Lagos', 'population' => 21.0],
  ['name' => 'Cairo', 'population' => 15.2],
  ['name' => 'Kinshasa-Brazzaville', 'population' => 11.3],
  ['name' => 'Greater Johannesburg', 'population' => 7.55],
  ['name' => 'Mogadishu', 'population' => 5.85],
  ['name' => 'Khartoum-Omdurman', 'population' => 4.98],
  ['name' => 'Dar Es Salaam', 'population' => 4.7],
  ['name' => 'Alexandria', 'population' => 4.58],
  ['name' => 'Abidjan', 'population' => 4.4],
  ['name' => 'Casablanca', 'population' => 3.98],
];
$found=0;
$search_name = 'Dar Es Salaam';
echo "Find the (zero-based) index of the first city in the list whose name is \"$search_name\" - 6";

$index = array_search($search_name, array_column($data_array, 'name'));
$population = $data_array[$index]['population'];
echo "\nAnswer 1: Index: [$index] Population for $search_name is $population Million\n";

$search_val = 5;
echo "\nFind the name of the first city in this list whose population is less than $search_val million - Khartoum-Omdurman";
foreach ($data_array as $index => $row) {
  if ($row['population'] < $search_val) {
    $name = $row['name'];
    echo "\nAnswer 2: Index [$index] Population for $row[name] is $row[population] Million\n";
    break;
  }
}

$search_term = 'A';
echo "\n\nFind the population of the first city in this list whose name starts with the letter \"$search_term\" - 4.58";
foreach ($data_array as $index => $row) {
  if (strpos($row['name'], $search_term) === 0) {
    echo "\nAnswer 3: Index: [$index] Population for $row[name] is $row[population] Million\n";
    break;
  }
}

echo "\nDone...";

Output:
Find the (zero-based) index of the first city in the list whose name is "Dar Es Salaam" - 6
Answer 1: Index: [6] Population for Dar Es Salaam is 4.7 Million

Find the name of the first city in this list whose population is less than 5 million - Khartoum-Omdurman
Answer 2: Index [5] Population for Khartoum-Omdurman is 4.98 Million

Find the population of the first city in this list whose name starts with the letter "A" - 4.58
Answer 3: Index: [7] Population for Alexandria is 4.58 Million

Done...
