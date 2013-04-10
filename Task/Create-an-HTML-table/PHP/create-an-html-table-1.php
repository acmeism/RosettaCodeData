<?php
/**
 * @author Elad Yosifon <elad.yosifon@gmail.com>
 * @desc HTML Table - native style
 */
$cols = array('', 'X', 'Y', 'Z');
$rows = 3;

$html = '<html><body><table><colgroup>';
foreach($cols as $col)
{
	$html .= '<col style="text-align: left;" />';
}
unset($col);
$html .= '</colgroup><thead><tr>';

foreach($cols as $col)
{
	$html .= "<td>{$col}</td>";
}
unset($col);

$html .= '</tr></thead><tbody>';
for($r = 1; $r <= $rows; $r++)
{
	$html .= '<tr>';
	foreach($cols as $key => $col)
	{
		$html .= '<td>' . (($key > 0) ? rand(1, 9999) : $r) . '</td>';
	}
	unset($col);
	$html .= '</tr>';
}
$html .= '</tbody></table></body></html>';

echo $html;
