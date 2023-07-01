function isemptydir(directory,nospecial)
	for filename in require('lfs').dir(directory) do
		if filename ~= '.' and filename ~= '..' then
			return false
		end
	end
	return true
end
