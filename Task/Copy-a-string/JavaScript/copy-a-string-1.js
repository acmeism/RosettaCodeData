var container = {myString: "Hello"};
var containerCopy = container; // Now both identifiers refer to the same object

containerCopy.myString = "Goodbye"; // container.myString will also return "Goodbye"
