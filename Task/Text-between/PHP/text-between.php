<?php
function text_between($string, $start, $end)
{
    //$string = " ".$string;
    $startIndex = strpos($string,$start);

    if ($start == "start")
    {
    	$startIndex = 0;
    } else {
    	if ($startIndex == 0)
    	{
    		return "Start text not found";
    	}
    }

    if ($end == "end")
    {
    	$endIndex=strlen($string);
    	$resultLength = $endIndex - $startIndex;
    } else {
	    $resultLength = strpos($string,$end,$startIndex) - $startIndex;
	}

    if ($start != "start")
    {
		$startIndex += strlen($start);
	}

    if ($resultLength <= 0)
    {
    	return "End text not found";
    }

    return substr($string,$startIndex,$resultLength);
}

$thisText=$_GET["thisText"];
$startDelimiter=$_GET["start"];
$endDelimiter=$_GET["end"];

$returnText = text_between($thisText, $startDelimiter, $endDelimiter);

print_r($returnText);
?>
