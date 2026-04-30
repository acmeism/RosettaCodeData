function remove( filename, starting_line, num_lines )
  local content = {}
  local i = 1
  for line in io.lines(filename, "L") do -- errors
    if i < starting_line or i >= starting_line + num_lines then
      content[#content+1] = line
	end
	i = i + 1
  end

  if i > starting_line and i < starting_line + num_lines then
    print( "Warning: Tried to remove lines after EOF." )
  end

  local fp = io.open( filename, "w+" ) or error"Not writable"
	fp:write( table.concat( content ) )
  fp:close()
end
