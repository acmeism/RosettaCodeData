var list:Vector.<String> = Vector.<String>(["Zig", "Zag", "Wally", "Ronald", "Bush", "Krusty", "Charlie", "Bush", "Boz", "Zag"]);
function lowIndex(listToSearch:Vector.<String>, searchString:String):int
{
	var index:int = listToSearch.indexOf(searchString);
	if(index == -1)
		throw new Error("String not found: " + searchString);
	return index;
}

function highIndex(listToSearch:Vector.<String>, searchString:String):int
{
	var index:int = listToSearch.lastIndexOf(searchString);
	if(index == -1)
		throw new Error("String not found: " + searchString);
	return index;
}
