<?php
function clip ($subjectPolygon, $clipPolygon) {

    function inside ($p, $cp1, $cp2) {
        return ($cp2[0]-$cp1[0])*($p[1]-$cp1[1]) > ($cp2[1]-$cp1[1])*($p[0]-$cp1[0]);
    }

    function intersection ($cp1, $cp2, $e, $s) {
        $dc = [ $cp1[0] - $cp2[0], $cp1[1] - $cp2[1] ];
        $dp = [ $s[0] - $e[0], $s[1] - $e[1] ];
        $n1 = $cp1[0] * $cp2[1] - $cp1[1] * $cp2[0];
        $n2 = $s[0] * $e[1] - $s[1] * $e[0];
        $n3 = 1.0 / ($dc[0] * $dp[1] - $dc[1] * $dp[0]);

        return [($n1*$dp[0] - $n2*$dc[0]) * $n3, ($n1*$dp[1] - $n2*$dc[1]) * $n3];
    }

    $outputList = $subjectPolygon;
    $cp1 = end($clipPolygon);
    foreach ($clipPolygon as $cp2) {
        $inputList = $outputList;
        $outputList = [];
        $s = end($inputList);
        foreach ($inputList as $e) {
            if (inside($e, $cp1, $cp2)) {
                if (!inside($s, $cp1, $cp2)) {
                    $outputList[] = intersection($cp1, $cp2, $e, $s);
                }
                $outputList[] = $e;
            }
            else if (inside($s, $cp1, $cp2)) {
                $outputList[] = intersection($cp1, $cp2, $e, $s);
            }
            $s = $e;
        }
        $cp1 = $cp2;
    }
    return $outputList;
}

$subjectPolygon = [[50, 150], [200, 50], [350, 150], [350, 300], [250, 300], [200, 250], [150, 350], [100, 250], [100, 200]];
$clipPolygon = [[100, 100], [300, 100], [300, 300], [100, 300]];
$clippedPolygon = clip($subjectPolygon, $clipPolygon);

echo json_encode($clippedPolygon);
echo "\n";
?>
