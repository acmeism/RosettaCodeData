import Foundation

let path = "input.txt"
do
{
	let string = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
	print(string) // print contents of file
}
catch
{
	print("error occured: \(error)")
}
