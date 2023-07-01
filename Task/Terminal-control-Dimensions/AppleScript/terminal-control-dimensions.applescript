local numColumns, numRows
tell application "Terminal"
	if not running then activate
	set {numColumns, numRows} to {number of columns, number of rows} of tab 1 of window 1
end tell
