	public static class Ex {
		public static List<object> Flatten(this List<object> list) {

			var result = new List<object>();
			foreach (var item in list) {
				if (item is List<object>) {
					result.AddRange(Flatten(item as List<object>));
				} else {
					result.Add(item);
				}
			}
			return result;
		}
		public static string Join<T>(this List<T> list, string glue) {
			return string.Join(glue, list.Select(i => i.ToString()).ToArray());
		}
	}

	class Program {

		static void Main(string[] args) {
			var list = new List<object>{new List<object>{1}, 2, new List<object>{new List<object>{3,4}, 5}, new List<object>{new List<object>{new List<object>{}}}, new List<object>{new List<object>{new List<object>{6}}}, 7, 8, new List<object>{}};

			Console.WriteLine("[" + list.Flatten().Join(", ") + "]");
			Console.ReadLine();
		}
	}
