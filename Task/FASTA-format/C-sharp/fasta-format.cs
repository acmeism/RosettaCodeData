using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

class Program
{
    public class FastaEntry
    {
        public string Name { get; set; }
        public StringBuilder Sequence { get; set; }
    }

    static IEnumerable<FastaEntry> ParseFasta(StreamReader fastaFile)
    {
        FastaEntry f = null;
        string line;
        while ((line = fastaFile.ReadLine()) != null)
        {
            // ignore comment lines
            if (line.StartsWith(";"))
                continue;

            if (line.StartsWith(">"))
            {
                if (f != null)
                    yield return f;
                f = new FastaEntry { Name = line.Substring(1), Sequence = new StringBuilder() };
            }
            else if (f != null)
                f.Sequence.Append(line);
        }
        yield return f;
    }

    static void Main(string[] args)
    {
        try
        {
            using (var fastaFile = new StreamReader("fasta.txt"))
            {
                foreach (FastaEntry f in ParseFasta(fastaFile))
                    Console.WriteLine("{0}: {1}", f.Name, f.Sequence);
            }
        }
        catch (FileNotFoundException e)
        {
            Console.WriteLine(e);
        }
        Console.ReadLine();
    }
}
