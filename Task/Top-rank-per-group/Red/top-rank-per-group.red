Red [
	Title: "Top Rank per Group"
	Author: "hinjolicious"
]

#include %../fp.red ; https://github.com/hinjolicious/functional

dat: {Employee Name,Employee ID,Salary,Department
Tyler Bennett,E10297,32000,D101
John Rappl,E21437,47000,D050
George Woltman,E00127,53500,D101
Adam Smith,E63535,18000,D202
Claire Buckman,E39876,27800,D202
David McClellan,E04242,41500,D101
Rich Holcomb,E01234,49500,D202
Nathan Adams,E41298,21900,D050
Richard Potter,E43128,15900,D101
David Motsinger,E27002,19250,D202
Tim Sampair,E03033,27000,D101
Kim Arlich,E10001,57000,D190
Timothy Grove,E16398,29900,D190}

top-sal: function [dat top][
	dat |> [replace/all it "^/" ","] |> [split it ","] |> [chunk it 4] |> [next it]
	
	||> [[name id sal dep] reduce [name id to-integer sal dep]]
	
	>- [[f [name id sal dep] #[]]
		either none? f/:dep [
			f/:dep: copy []
			append/only f/:dep reduce [name id sal]
		][
			append/only f/:dep reduce [name id sal]
		]
		f
	]
		
	|> [foreach [dep id] it [
			print ["^/Dept." dep "^/"]
			sort/compare id func [a b][a/3 > b/3]
			repeat i top [
				if none? id/:i [continue]
				print ["  " pad id/:i/1 15 pad id/:i/2 8 pad id/:i/3 8]
			]
		]
	]
]	

print "Top Three Highest Salary per Department"
top-sal dat 3
