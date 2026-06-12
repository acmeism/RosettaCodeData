?- last_list_item_heap([6, 81, 243, 14, 25, 49, 123, 69, 11], LastItem).
LastItem = 621.

?- debug(last_list_item_heap), last_list_item_heap([6, 81, 243, 14, 25, 49, 123, 69, 11], LastItem).

17 is 6+11
31 is 14+17
56 is 25+31
105 is 49+56
150 is 69+81
228 is 105+123
378 is 150+228
621 is 243+378
LastItem = 621.
