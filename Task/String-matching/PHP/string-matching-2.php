<?php
<!DOCTYPE html>
<!--
/************************************************************************
* Here we prompt the user for a haystack and a needle
* We then invoke program chmx.php
* to check for occurrences of the needle in the haystack
* 02.05.2013 Walter Pachl
* Comments or Suggestions welcome
************************************************************************/
-->
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Character matching</title>
  </head>
  <body>
    <form id="test" name="test" method="post" action="chmx.php">
    <h1>Character matching</h1>
    <p>Given two strings, demonstrate the following 3 types of matchings:
    <ol style="margin-top:2; margin-bottom:2;">
    <li>Determining if the first string starts with second string
    <li>Determining if the first string contains the second string at any location
    <li>Determining if the first string ends with the second string
    </ol>
    <p>Optional requirements:
    <ol style="margin-top:2; margin-bottom:2;">
    <li>Print the location of the match(es) for part 2
    <li>Handle multiple occurrences of a string for part 2.
    </ol>
    <p style="margin-top:5; margin-bottom:3;">
       <font face="Courier"><strong>Haystack:</strong>
       <strong><input type="text" name="haystack" size="80"></strong></font></p>
    <p style="margin-top:5; margin-bottom:3;">
       <font face="Courier"><strong>Needle:&nbsp;&nbsp;</strong>
       <strong><input type="text" name="needle" size="80"></strong></font></p>
    <p>Press <input name="Submit" type="submit" class="erfolg" value="CHECK"/>
       to invoke chmx.php.</p>
  </form>
  </body>
</html>
