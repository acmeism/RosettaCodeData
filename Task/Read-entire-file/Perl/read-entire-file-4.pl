use IO::All;
$text = io($filename)->all;
$text = io($filename)->utf8->all;
@text = io($filename)->slurp;
$text < io($filename);
io($filename) > $text;
