[
  { str reverse }
  { split words | str reverse | str join ' ' }
  { split words | reverse | str join ' ' }
]
| each {|code| 'rosetta code phrase reversal' | do $code }
