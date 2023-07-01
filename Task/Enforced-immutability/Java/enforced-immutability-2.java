final String immutableString = "test";
immutableString = new String("anotherTest"); //this is an error
final StringBuffer immutableBuffer = new StringBuffer();
immutableBuffer.append("a"); //this is fine and it changes the state of the object
immutableBuffer = new StringBuffer("a"); //this is an error
