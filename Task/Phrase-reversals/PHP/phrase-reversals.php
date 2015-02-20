<?php
// Initialize a variable with the input desired
$strin = "rosetta code phrase reversal";

// Show user what original input was
echo "Input: ".$strin."\n";

// Show the full input reversed
echo "Reversed: ".strrev($strin)."\n";

// reverse the word letters in place
$str_words_reversed = "";
$temp = explode(" ", $strin);
foreach($temp as $word)
	$str_words_reversed .= strrev($word)." ";

// Show the reversed words in place
echo "Words reversed: ".$str_words_reversed."\n";


// reverse the word order while leaving the words in order
$str_word_order_reversed = "";
$temp = explode(" ", $strin);
for($i=(count($temp)-1); $i>=0; $i--)
	$str_word_order_reversed .= $temp[$i]." ";

// Show the reversal of the word order while leaving the words in order
echo "Word order reversed: ".$str_word_order_reversed."\n";
