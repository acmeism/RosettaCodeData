<?php foreach(range(99,1) as $i):?>
<?=$i?> bottle<?=$i==1 ? '' : 's'?> of beer on the wall,
<?=$i?> bottle<?=$i==1 ? '' : 's'?> of beer!
Take one down, pass it around...
<?php if($i > 1):?>
<?=$i-1?> bottle<?=$i==1 ? '' : 's'?> of beer on the wall!
<?php else:?>
No more bottles of beer on the wall!
<?php endif?>
<?php endforeach?>
