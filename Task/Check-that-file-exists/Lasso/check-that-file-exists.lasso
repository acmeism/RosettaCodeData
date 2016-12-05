// local file
file_exists('input.txt')

// local directory
file_exists('docs')

// file in root file system (requires permissions at user OS level)
file_exists('//input.txt')

// directory in root file system (requires permissions at user OS level)
file_exists('//docs')
