local(original = json_deserialize('[[1], 2, [[3,4], 5], [[[]]], [[[6]]], 7, 8, []]'))

#original
'<br />'
(with item in delve(#original)
select #item) -> asstaticarray
