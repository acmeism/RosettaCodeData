namespace Permutations_On_RosettaCode
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] list = "a b c d".Split();
            foreach (string[] permutation in Permutations<string>.AllFor(list))
            {
                System.Console.WriteLine(string.Join(" ", permutation));
            }
        }
    }
}
