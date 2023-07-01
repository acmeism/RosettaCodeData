<?php
$colors = array(
                "000000",   // black
                "FF0000",   // red
                "00FF00",   // green
                "0000FF",   // blue
                "FF00FF",   // magenta
                "00FFFF",   // cyan
                "FFFF00",   // yellow
                "FFFFFF",   // white
                );

echo '<table style="border: 1px solid black; border-spacing: 0;"><tr>';
foreach ($colors as $color) {
    echo '<td style="background-color: #'.$color.'; height: 100px; width: 20px;"></td>';
}
echo '</tr></table>';
