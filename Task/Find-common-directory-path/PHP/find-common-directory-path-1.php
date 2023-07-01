<?php

/*
 This works with dirs and files in any number of combinations.
*/

function _commonPath($dirList)
{
	$arr = array();
	foreach($dirList as $i => $path)
	{
		$dirList[$i]	= explode('/', $path);
		unset($dirList[$i][0]);
		
		$arr[$i] = count($dirList[$i]);
	}
	
	$min = min($arr);
	
	for($i = 0; $i < count($dirList); $i++)
	{
		while(count($dirList[$i]) > $min)
		{
			array_pop($dirList[$i]);
		}
		
		$dirList[$i] = '/' . implode('/' , $dirList[$i]);
	}
	
	$dirList = array_unique($dirList);
	while(count($dirList) !== 1)
	{
		$dirList = array_map('dirname', $dirList);
		$dirList = array_unique($dirList);
	}
	reset($dirList);
	
	return current($dirList);
}

 /* TEST */

$dirs = array(
 '/home/user1/tmp/coverage/test',
 '/home/user1/tmp/covert/operator',
 '/home/user1/tmp/coven/members',
);


if('/home/user1/tmp' !== common_path($dirs))
{
  echo 'test fail';
} else {
  echo 'test success';
}

?>
