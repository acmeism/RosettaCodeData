print  1  + '2';  # 3
print '1' + '2';  # 3
print  1  .  1;   # 11

$a = 1;
$b = 2;
say "$a+$b";  # 1+2

# Even if you intentionally jumble the expected roles of numbers and strings, thing just work out
say hex int( (2 . 0 x '2') ** substr 98.5, '2', '2' ) . 'beef'; # 1359599
