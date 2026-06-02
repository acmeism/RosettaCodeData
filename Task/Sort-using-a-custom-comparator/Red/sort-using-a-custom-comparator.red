Red [Title: "Sort using a custom comparator" Author: "hinjolicious"]

print sort/compare
	split "Here are some sample strings to be sorted" " "
	func [a b][la: length? a lb: length? b either la = lb [a < b][la > lb]]
