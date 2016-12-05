-- Finds all possible solutions and the unique patterns.

property Grid_Size : 8

property Patterns : {}
property Solutions : {}
property Test_Count : 0

property Rotated : {}

on run
	local diff
	local endTime
	local msg
	local rows
	local startTime
	
	set Patterns to {}
	set Solutions to {}
	set Rotated to {}
	
	set Test_Count to 0
	
	set rows to Make_Empty_List(Grid_Size)
	
	set startTime to current date
	Solve(1, rows)
	set endTime to current date
	set diff to endTime - startTime
	
	set msg to ("Found " & (count Solutions) & " solutions with " & (count Patterns) & " patterns in " & diff & " seconds.") as text
	display alert msg
end run

on Solve(row as integer, rows as list)
	if row is greater than (count rows) then
		Append_Solution(rows)
		return
	end if
	
	repeat with column from 1 to Grid_Size
		set Test_Count to Test_Count + 1
		if Place_Queen(column, row, rows) then
			Solve(row + 1, rows)
		end if
	end repeat
end Solve

on Place_Queen(column as integer, row as integer, rows as list)
	local colDiff
	local previousRow
	local rowDiff
	local testColumn
	
	repeat with previousRow from 1 to (row - 1)
		set testColumn to item previousRow of rows
		
		if testColumn is equal to column then
			return false
		end if
		
		set colDiff to abs (testColumn - column) as integer
		set rowDiff to row - previousRow
		if colDiff is equal to rowDiff then
			return false
		end if
	end repeat
	
	set item row of rows to column
	return true
end Place_Queen

on Append_Solution(rows as list)
	local column
	local rowsCopy
	local testReflection
	local testReflectionText
	local testRotation
	local testRotationText
	local testRotations
	
	copy rows to rowsCopy
	set end of Solutions to rowsCopy
	local rowsCopy
	
	copy rows to testRotation
	set testRotations to {}
	repeat 3 times
		set testRotation to Rotate(testRotation)
		set testRotationText to testRotation as text
		if Rotated contains testRotationText then
			return
		end if
		set end of testRotations to testRotationText
		
		set testReflection to Reflect(testRotation)
		set testReflectionText to testReflection as text
		if Rotated contains testReflectionText then
			return
		end if
		set end of testRotations to testReflectionText
	end repeat
	
	repeat with testRotationText in testRotations
		set end of Rotated to (contents of testRotationText)
	end repeat
	set end of Rotated to (rowsCopy as text)
	set end of Rotated to (Reflect(rowsCopy) as text)
	
	set end of Patterns to rowsCopy
end Append_Solution

on Make_Empty_List(depth as integer)
	local i
	local emptyList
	
	set emptyList to {}
	repeat with i from 1 to depth
		set end of emptyList to missing value
	end repeat
	return emptyList
end Make_Empty_List

on Rotate(rows as list)
	local column
	local newColumn
	local newRow
	local newRows
	local row
	local rowCount
	
	set rowCount to (count rows)
	set newRows to Make_Empty_List(rowCount)
	repeat with row from 1 to rowCount
		set column to (contents of item row of rows)
		set newRow to column
		set newColumn to rowCount - row + 1
		set item newRow of newRows to newColumn
	end repeat
	
	return newRows
end Rotate

on Reflect(rows as list)
	local column
	local newRows
	
	set newRows to {}
	repeat with column in rows
		set end of newRows to (count rows) - column + 1
	end repeat
	
	return newRows
end Reflect
