declare function local:hanoi($disk as xs:integer, $from as xs:integer,
    $to as xs:integer, $via as xs:integer) as element()*
{
  if($disk > 0)
  then (
    local:hanoi($disk - 1, $from, $via, $to),
    <move disk='{$disk}'><from>{$from}</from><to>{$to}</to></move>,
    local:hanoi($disk - 1, $via, $to, $from)
  )
  else ()
};

<hanoi>
{
  local:hanoi(4, 1, 2, 3)
}
</hanoi>
