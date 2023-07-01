using System;
using System.Collections.Generic;

class Node
{
	public enum Colors
	{
		Black, White, Gray
	}

	public Colors color { get; set; }
	public int N { get; }
	
	public Node(int n)
	{
		N = n;
		color = Colors.White;
	}
}

class Graph
{
	public HashSet<Node> V { get; }
	public Dictionary<Node, HashSet<Node>> Adj { get; }

	/// <summary>
	/// Kosaraju's strongly connected components algorithm
	/// </summary>
	public void Kosaraju()
	{
		var L = new HashSet<Node>();

		Action<Node> Visit = null;
		Visit = (u) =>
		{
			if (u.color == Node.Colors.White)
			{
				u.color = Node.Colors.Gray;

				foreach (var v in Adj[u])
					Visit(v);

				L.Add(u);
			}
		};

		Action<Node, Node> Assign = null;
		Assign = (u, root) =>
		{
			if (u.color != Node.Colors.Black)
			{
				if (u == root)
					Console.Write("SCC: ");

				Console.Write(u.N + " ");
				u.color = Node.Colors.Black;

				foreach (var v in Adj[u])
					Assign(v, root);

				if (u == root)
					Console.WriteLine();
			}
		};

		foreach (var u in V)
			Visit(u);

		foreach (var u in L)
			Assign(u, u);
	}
}
