using System;
using System.Linq;

class BankerAlgorithm
{
    static void Main()
    {
        try
        {
            // 1. Read Input Sizes
            Console.Write("Number of resources: ");
            int resources = int.Parse(Console.ReadLine());
            Console.Write("Number of processes: ");
            int processes = int.Parse(Console.ReadLine());

            // 2. Read Maximum Resources
            Console.Write("Maximum resources (space-separated): ");
            int[] maxResources = Console.ReadLine()
                .Trim()
                .Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                .Select(int.Parse)
                .ToArray();

            // 3. Read Currently Allocated Resources for each process
            int[][] currentlyAllocated = new int[processes][];
            Console.WriteLine("\n-- resources allocated for each process --");
            for (int i = 0; i < processes; i++)
            {
                Console.Write($"process {i + 1}: ");
                currentlyAllocated[i] = Console.ReadLine()
                    .Trim()
                    .Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(int.Parse)
                    .ToArray();
            }

            // 4. Read Maximum Need for each process
            int[][] maxNeed = new int[processes][];
            Console.WriteLine("\n--- maximum resources for each process ---");
            for (int i = 0; i < processes; i++)
            {
                Console.Write($"process {i + 1}: ");
                maxNeed[i] = Console.ReadLine()
                    .Trim()
                    .Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(int.Parse)
                    .ToArray();
            }

            // 5. Calculate Total Allocated Resources
            int[] allocated = new int[resources];
            for (int i = 0; i < processes; i++)
            {
                for (int j = 0; j < resources; j++)
                {
                    allocated[j] += currentlyAllocated[i][j];
                }
            }
            Console.WriteLine($"\nTotal resources allocated: [{string.Join(", ", allocated)}]");

            // 6. Calculate Available Resources
            int[] available = new int[resources];
            for (int i = 0; i < resources; i++)
            {
                available[i] = maxResources[i] - allocated[i];
                if (available[i] < 0)
                {
                    Console.Error.WriteLine($"Error: Calculated available resources are negative for resource {i}. Check input consistency.");
                    return;
                }
            }
            Console.WriteLine($"Total resources available: [{string.Join(", ", available)}]\n");

            // 7. Banker's Algorithm (Safety Check)
            bool[] running = new bool[processes];
            // Replace Array.Fill with manual initialization
            for (int i = 0; i < processes; i++)
            {
                running[i] = true;
            }
            int count = processes;

            while (count > 0)
            {
                bool safe = false;

                for (int i = 0; i < processes; i++)
                {
                    if (running[i])
                    {
                        bool canExecute = true;
                        for (int j = 0; j < resources; j++)
                        {
                            int needed = maxNeed[i][j] - currentlyAllocated[i][j];
                            if (needed > available[j])
                            {
                                canExecute = false;
                                break;
                            }
                        }

                        if (canExecute)
                        {
                            Console.WriteLine($"process {i + 1} running");
                            running[i] = false;
                            count--;
                            safe = true;

                            for (int j = 0; j < resources; j++)
                            {
                                available[j] += currentlyAllocated[i][j];
                            }

                            break;
                        }
                    }
                }

                if (!safe)
                {
                    Console.WriteLine("The process is in an unsafe state.");
                    break;
                }
                else
                {
                    Console.WriteLine("The process is in a safe state.");
                    Console.WriteLine($"Available resources: [{string.Join(", ", available)}]\n");
                }
            }

            if (count == 0)
            {
                Console.WriteLine("\nAll processes finished successfully. The initial state was safe.");
            }
        }
        catch (FormatException)
        {
            Console.Error.WriteLine("Error: Invalid number format entered. Please enter integers only.");
        }
        catch (IndexOutOfRangeException)
        {
            Console.Error.WriteLine("Error: Incorrect number of values entered on a line.");
        }
        catch (Exception e)
        {
            Console.Error.WriteLine($"An unexpected error occurred: {e.Message}");
        }
    }
}
