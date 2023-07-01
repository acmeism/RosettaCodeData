set {array, sum, product} to {{1, 2, 3, 4, 5}, 0, 1}
repeat with i in array
	set {sum, product} to {sum + i, product * i}
end repeat
return sum & " , " & product as string
