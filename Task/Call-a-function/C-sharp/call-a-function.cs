/* a function that has no argument */
	public int MyFunction();

	/* a function with a fixed number of arguments */
	FunctionWithArguments(4, 3, 2);

	/* a function with optional arguments */
	public void OptArg();

	public static void Main()
	{
		OptArg(1);
		OptArg(1, 2);
		OptArg(1, 2, 3);
	}
	public void ExampleMethod(int required,
        string optionalstr = "default string",
		int optionalint = 10)
	/* If you know the first and the last parameter */
	ExampleMethod(3, optionalint: 4);

	/* If you know all the parameter */
	ExampleMethod(3, "Hello World", 4);

	/* Variable number of arguments use array */
	public static void UseVariableParameters(params int[] list)

	/* Obtain return value from function */
	public internal MyFunction();
	int returnValue = MyFunction();
