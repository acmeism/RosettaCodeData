<?php

 function strInv ($string) {

 	$str_inv = '' ;

	 for ($i=0,$s=count($string);$i<$s;$i++){
	 	$str_inv .= implode(' ',array_reverse(explode(' ',$string[$i])));
	 	$str_inv .= '<br>';
	 }

 	return $str_inv;

 }

 $string[] =  "---------- Ice and Fire ------------";
 $string[] =  "";
 $string[] =  "fire, in end will world the say Some";
 $string[] =  "ice. in say Some";
 $string[] =  "desire of tasted I've what From";
 $string[] =  "fire. favor who those with hold I";
 $string[] =  "";
 $string[] =  "... elided paragraph last ...";
 $string[] =  "";
 $string[] =  "Frost Robert ----------------------- ";


echo strInv($string);
