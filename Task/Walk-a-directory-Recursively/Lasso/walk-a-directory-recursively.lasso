// care only about visible files and filter out any directories
define dir -> eachVisibleFilePath() => {
	return with name in self -> eachEntry where #name -> second != io_dir_dt_dir where not(#name -> first  ->  beginswith('.')) select .makeFullPath(#name -> first)
}

// care only about visible directories and filter out any files
define dir -> eachVisibleDir() => {
	return with name in self -> eachEntry where #name -> second == io_dir_dt_dir where not(#name -> first -> beginswith('.')) select dir(.makeFullPath(#name -> first + '/'))
}

// Recursively walk the directory tree and find all files and directories
// return only paths to files
define dir -> eachVisibleFilePathRecursive(-dirFilter = void) => {
	local(files = .eachVisibleFilePath)
	with dir in .eachVisibleDir
	where !#dirFilter || #dirFilter(#dir -> realPath)
	do {
		#files = tie(#files, #dir -> eachVisibleFilePathRecursive(-dirFilter = #dirFilter))
	}
	return #files
}

local(matchingfilenames = array)

with filepath in dir('/') -> eachVisibleFilePathRecursive
where #filepath -> endswith('.lasso')
let filename = #filepath -> split('/') -> last
do #matchingfilenames -> insert(#filename)

#matchingfilenames
