$a = mb_convert_encoding('&#x1F466;&#x1F3FB;&#x1f44b;', 'UTF-8', 'HTML-ENTITIES'); // 👦🏻👋

function str_to_array($string)
{
  $length = grapheme_strlen($string);
  $ret = [];

  for ($i = 0; $i < $length; $i += 1) {

    $ret[] = grapheme_substr($string, $i, 1);
  }

  return $ret;
}

function utf8_strrev($string)
{
  return implode(array_reverse(str_to_array($string)));
}

print_r(utf8_strrev($a)); // 👋👦🏻
