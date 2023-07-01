<?php
function time2ang($tim) {
        if (!is_string($tim)) return $tim;
        $parts = explode(':',$tim);
        if (count($parts)!=3) return $tim;
        $sec = ($parts[0]*3600)+($parts[1]*60)+$parts[2];
        $ang = 360.0 * ($sec/86400.0);
        return $ang;
}
function ang2time($ang) {
        if (!is_numeric($ang)) return $ang;
        $sec = 86400.0 * $ang / 360.0;
        $parts = array(floor($sec/3600),floor(($sec % 3600)/60),$sec % 60);
        $tim = sprintf('%02d:%02d:%02d',$parts[0],$parts[1],$parts[2]);
        return $tim;
}
function meanang($ang) {
        if (!is_array($ang)) return $ang;
        $sins = 0.0;
        $coss = 0.0;
        foreach($ang as $a) {
                $sins += sin(deg2rad($a));
                $coss += cos(deg2rad($a));
        }
        $avgsin = $sins / (0.0+count($ang));
        $avgcos = $coss / (0.0+count($ang));
        $avgang = rad2deg(atan2($avgsin,$avgcos));
        while ($avgang < 0.0) $avgang += 360.0;
        return $avgang;
}
$bats = array('23:00:17','23:40:20','00:12:45','00:17:19');
$angs = array();
foreach ($bats as $t) $angs[] = time2ang($t);
$ma = meanang($angs);
$result = ang2time($ma);
print "The mean time of day is $result (angle $ma).\n";
?>
