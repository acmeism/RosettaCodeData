let $maxentries := 10,
    $uri := 'https://www.gutenberg.org/files/135/135-0.txt'
return
<words in="{$uri}" top="{$maxentries}"> {
(
  let $doc := unparsed-text($uri),
  $tokens := (
               tokenize($doc, '\W+')[normalize-space()]
                 ! lower-case(.)
                 ! normalize-unicode(., 'NFC')
             )
  return
    for $token in $tokens
    let $key := $token
    group by $key
    let $count := count($token)
    order by $count descending
    return <word key="{$key}" count="{$count}"/>
)[position()=(1 to $maxentries)]
}</words>
