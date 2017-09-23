<?php
    $Anerisia = array(31,28,31,30,31,30,31,31,30,31,30,31);
    $MONTHS = array("Choas","Discord","Confusion","Bureacracy","The Aftermath");
    $DAYS = array("Setting Orange","Sweetmorn","BoomTime","Pungenday","Prickle-Prickle");
    $Dsuff = array('th','st','nd','rd','th','th','th','th','th','th');
    $Holy5 = array("Mungday","MojoDay","Syaday","Zaraday","Maladay");
    $Holy50 = array("Chaoflux","Discoflux","Confuflux","Bureflux","Afflux");




    // Get the current system date and assign to some variables
	$edate = explode(" ",date('Y m j L'));
	$usery = $edate[0];
	$userm = $edate[1];
	$userd = $edate[2];
	$IsLeap = $edate[3];

  // If the user supplied us with a date overide the one we got from the system.
  // If you could get the date from users browser via javascript and then call
  // this script with the users date. ddate.php?y=year&m=month&d=day mostly it
  // won't matter but if the server is in a different time zone to the user
  // There will be occasional incorrect results from the users POV.

    if (isset($_GET['y']) && isset($_GET['m']) && isset($_GET['d'])) {
        $usery = $_GET['y'];
        $userm = $_GET['m'];
        $userd = $_GET['d'];
        $IsLeap = 0;
        if (($usery%4 == 0) && ($usery%100 >0)) $IsLeap =1;
        if ($usery%400 == 0) $IsLeap = 1;
    }

 // We need to know the total number of days in the year so far

    $userdays = 0;
    $i = 0;
    while ($i < ($userm-1)) {

        $userdays = $userdays + $Anerisia[$i];
        $i = $i +1;
    }
    $userdays = $userdays + $userd;

    // We can now work out the full discordian date for most dates
    // PHP does not do integer division, so we use 73.2 as a divisor
    // the value 73.2 works, larger values cause an off-by-one on season
    // changes for the later seasons .
    // This is not needed with the mod operator.

    $IsHolyday = 0;
    $dyear = $usery + 1166;
    $dmonth = $MONTHS[$userdays/73.2];
    $dday = $userdays%73;
	if (0 == $dday) $dday = 73;
    $Dname = $DAYS[$userdays%5];
    $Holyday = "St. Tibs Day";
    if ($dday == 5) {
        $Holyday = $Holy5[$userdays/73.2];
        $IsHolyday =1;
    }
    if ($dday == 50) {
        $Holyday = $Holy50[$userdays/73.2];
        $IsHolyday =1;
    }

  if (($IsLeap ==1) && ($userd ==29) and ($userm ==2)) $IsHolyday = 2;

   // work out the suffix to the day number
   $suff = $Dsuff[$dday%10] ;
   if ((11 <= $dday) && (19 >= $dday)) $suff='th';

    // code to display the date ...

 if ($IsHolyday ==2)
      echo "</br>Celeberate ",$Holyday," ",$dmonth," YOLD ",$dyear;
    if ($IsHolyday ==1)
      echo "</br>Celeberate for today ", $Dname , " The ", $dday,"<sup>",$suff,"</sup>", " day of ", $dmonth , " YOLD " , $dyear , " is the holy day of " , $Holyday;
    if ($IsHolyday == 0)
       echo "</br>Today is " , $Dname , " the " , $dday ,"<sup>",$suff, "</sup> day of " , $dmonth , " YOLD " , $dyear;

 ?>
