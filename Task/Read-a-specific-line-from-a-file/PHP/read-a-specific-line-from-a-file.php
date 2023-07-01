<?php
  $DOCROOT = $_SERVER['DOCUMENT_ROOT'];

  function fileLine ($lineNum, $file) {
    $count = 0;
    while (!feof($file)) {
      $count++;
      $line = fgets($file);
      if ($count == $lineNum) return $line;
    }
    die("Requested file has fewer than ".$lineNum." lines!");
  }

  @ $fp = fopen("$DOCROOT/exercises/words.txt", 'r');
  if (!$fp) die("Input file not found!");
  echo fileLine(7, $fp);
?>
