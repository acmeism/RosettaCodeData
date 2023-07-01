{
  "item": 1,
  "next": {
    "item": 2,
    "next": null
  }
}
| reduce items as $item (null; .+$item),
  map_singly_linked_list(- .)
