<?
function makeList($separator) {
  $counter = 1;

  $makeItem = function ($item) use ($separator, &$counter) {
    return $counter++ . $separator . $item . "\n";
  };

  return $makeItem("first") . $makeItem("second") . $makeItem("third");
}

echo makeList(". ");
?>
