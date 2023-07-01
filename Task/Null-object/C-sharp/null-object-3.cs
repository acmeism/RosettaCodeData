Console.WriteLine(name ?? "Name not specified");

//Without the null coalescing operator, this would instead be written as:
//if(name == null){
//	Console.WriteLine("Name not specified");
//}else{
//	Console.WriteLine(name);
//}
