def table_sort(table, opts = {})
  defaults = {:ordering => :<=>, :column => 0, :reverse => false}
  opts = defaults.merge(opts)

  c = opts[:column]
  p = opts[:ordering].to_proc
  if opts[:reverse]
    table.sort {|a, b| p.call(b[c], a[c])}
  else
    table.sort {|a, b| p.call(a[c], b[c])}
  end
end
