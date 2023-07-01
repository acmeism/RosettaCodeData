                       // simple solution
                       string input = Console.ReadLine();
			if (input.Length % 2 != 0)
			{
				Console.WriteLine("Not Okay");
				return;
			}
			for (int i = 0; i < input.Length; i++)
			{
				if (i < input.Length - 1)
				{
					if (input[i] == '[' && input[i + 1] == ']')
					{
						input = input.Remove(i, 2);
						i = -1;
					}
				}
	
			}
			if (input.Length == 0)
				Console.WriteLine("Okay");
			else
				Console.WriteLine("Not Okay");
