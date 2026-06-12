using System;
using System.Collections.Generic;
using System.Linq;

public static class HierholzesAlgorithm
{
    public static void Main(string[] args)
    {
        var adjacencyList1 = new List<List<int>>();
        adjacencyList1.Add(new List<int> { 1 });
        adjacencyList1.Add(new List<int> { 2 });
        adjacencyList1.Add(new List<int> { 0 });

        PrintCircuit(adjacencyList1);

        var adjacencyList2 = new List<List<int>>();
        adjacencyList2.Add(new List<int> { 1, 6 });
        adjacencyList2.Add(new List<int> { 2 });
        adjacencyList2.Add(new List<int> { 0, 3 });
        adjacencyList2.Add(new List<int> { 4 });
        adjacencyList2.Add(new List<int> { 2, 5 });
        adjacencyList2.Add(new List<int> { 0 });
        adjacencyList2.Add(new List<int> { 4 });

        PrintCircuit(adjacencyList2);
    }

    public static void PrintCircuit(List<List<int>> adjacencyList)
    {
        if (adjacencyList.Count == 0)
        {
            return;
        }

        var path = new Stack<int>();
        var circuit = new List<int>();

        int currentVertex = 0; // Start at vertex 0
        path.Push(currentVertex);

        while (path.Count > 0)
        {
            if (adjacencyList[currentVertex].Count > 0)
            {
                path.Push(currentVertex);
                int nextVertex = adjacencyList[currentVertex].Last();
                adjacencyList[currentVertex].RemoveAt(adjacencyList[currentVertex].Count - 1);
                currentVertex = nextVertex;
            }
            else // Back-tracking
            {
                circuit.Add(currentVertex);
                currentVertex = path.Pop();
            }
        }

        // Print the circuit
        for (int i = circuit.Count - 1; i >= 0; i--)
        {
            Console.Write(circuit[i]);
            if (i != 0)
            {
                Console.Write(" => ");
            }
        }
        Console.WriteLine();
    }
}
