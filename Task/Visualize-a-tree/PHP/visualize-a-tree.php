<?php

function printTree( array $tree , string $key = "." , string $stack = "" , $first = TRUE , $firstPadding = NULL )
{
    if ( gettype($tree) == "array" )
    {
        if($firstPadding === NULL) $firstPadding = ( count($tree)>1 ) ? "│   " : "    " ;
        echo   $key . PHP_EOL ;
        foreach ($tree as $key => $value) {
            if ($key === array_key_last($tree)){
                echo (($first) ? "" : $firstPadding ) . $stack . "└── ";
                $padding = "    ";
                if($first) $firstPadding = "    ";
            }
            else {
                echo (($first) ? "" : $firstPadding ) . $stack . "├── ";
                $padding = "│   ";
            }
            if( is_array($value) )printTree( $value , $key ,   $stack . (($first) ? "" : $padding ) , FALSE , $firstPadding );
            else echo $key . " -> " . $value . PHP_EOL;
        }
    }
    else echo $tree . PHP_EOL;
}



// ---------------------------------------TESTING FUNCTION-------------------------------------


$sample_array_1 =
[
    0 => [
        'item_id' => 6,
        'price' => "2311.00",
        'qty' => 12,
        'discount' => 0
    ],
    1 => [
        'item_id' => 7,
        'price' => "1231.00",
        'qty' => 1,
        'discount' => 12
    ],
    2 => [
        'item_id' => 8,
        'price' => "123896.00",
        'qty' => 0,
        'discount' => 24
    ]
];
$sample_array_2 = array(
    array(
         "name"=>"John",
        "lastname"=>"Doe",
        "country"=>"Japan",
        "nationality"=>"Japanese",
        "job"=>"web developer",
        "hobbies"=>array(
                "sports"=>"soccer",
                "others"=>array(
                        "freetime"=>"watching Tv"
                )
        )

    )
);
$sample_array_3 = [
    "root" => [
        "first_depth_node1" =>[
            "second_depth_node1",
            "second_depth_node2" => [
                "third_depth_node1" ,
                "third_depth_node2" ,
                "third_depth_node3" => [
                    "fourth_depth_node1",
                    "fourth_depth_node2",
                ]
                ],
            "second_depth_node3",
        ] ,
        "first_depth_node2" => [
            "second_depth_node4" => [ "third_depth_node3" => [1]]
        ]
        ]
];
$sample_array_4 = [];
$sample_array_5 = ["1"];
$sample_array_5 = ["1"];
$sample_array_6 = [
    "T",
    "Ta",
    "Tad",
    "Tada",
    "Tadav",
    "Tadavo",
    "Tadavom",
    "Tadavomn",
    "Tadavomni",
    "Tadavomnis",
    "TadavomnisT",
];


printTree($sample_array_1);
echo PHP_EOL . "------------------------------" . PHP_EOL;
printTree($sample_array_2);
echo PHP_EOL . "------------------------------" . PHP_EOL;
printTree($sample_array_3);
echo PHP_EOL . "------------------------------" . PHP_EOL;
printTree($sample_array_4);
echo PHP_EOL . "------------------------------" . PHP_EOL;
printTree($sample_array_5);
echo PHP_EOL . "------------------------------" . PHP_EOL;
printTree($sample_array_6);


?>
