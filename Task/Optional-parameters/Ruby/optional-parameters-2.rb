def table_sort(table, ordering: :<=>, column: 0, reverse: false)
  p = ordering.to_proc
  if reverse
    table.sort {|a, b| p.(b[column], a[column])}
  else
    table.sort {|a, b| p.(a[column], b[column])}
  end
end

# Quick example:
table = [
  ["Ottowa", "Canada"],
  ["Washington", "USA"],
  ["Mexico City", "Mexico"],
]
p table_sort(table, column: 1)
