<?php
/**
 * @author Elad Yosifon <elad.yosifon@gmail.com>
 * @desc HTML Table - spaghetti-code style
 */
$cols = array('', 'X', 'Y', 'Z');
$rows = 3;
?>
<html>
<body>
<table>
	<colgroup>
	<?php foreach($cols as $col):?>
		<col style="text-align: left;" />
	<?php endforeach; unset($col) ?>
	</colgroup>
	<thead>
		<tr>
			<?php foreach($cols as $col): ?>
			<td><?php echo $col?></td>
			<?php endforeach; unset($col)?>
		</tr>
	</thead>
	<tbody>
		<?php for($r = 1; $r <= $rows; $r++): ?>
		<tr>
			<?php foreach($cols as $key => $col): ?>
			<td><?php echo ($key > 0) ? rand(1, 9999) : $r ?></td>
			<?php endforeach; unset($col) ?>
		</tr>
		<?php endfor; ?>
	</tbody>
</table>
</body>
</html>
