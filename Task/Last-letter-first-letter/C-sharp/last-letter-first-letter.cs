using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            string pokemon_names = @"audino bagon baltoy banette bidoof braviary bronzor carracosta charmeleon
cresselia croagunk darmanitan deino emboar emolga exeggcute gabite
girafarig gulpin haxorus heatmor heatran ivysaur jellicent jumpluff kangaskhan
kricketune landorus ledyba loudred lumineon lunatone machamp magnezone mamoswine
nosepass petilil pidgeotto pikachu pinsir poliwrath poochyena porygon2
porygonz registeel relicanth remoraid rufflet sableye scolipede scrafty seaking
sealeo silcoon simisear snivy snorlax spoink starly tirtouga trapinch treecko
tyrogue vigoroth vulpix wailord wartortle whismur wingull yamask";

            string[] pokemon = pokemon_names.Split(new char[]{' ','\n'});
            List<string> chain = new List<string>(pokemon.Length);

            for (int i = 0; i < pokemon.Length; i++)
            {
                swap(ref pokemon[0], ref pokemon[i]);
                Search( pokemon, chain, 1 );
                swap(ref pokemon[0], ref pokemon[i]);
            }

            foreach (string s in chain)
                Console.WriteLine(s);

            Console.ReadKey();
        }

        static void Search(string[] pokemon, List<string> longest_chain, int len )
        {
            if (len > longest_chain.Count)
            {
                longest_chain.Clear();
                for (int i = 0; i < len; i++)
                    longest_chain.Add(pokemon[i]);
            }

            char lastchar = pokemon[len - 1][pokemon[len-1].Length - 1];
            for (int i = len; i < pokemon.Length; i++)
            {
                if (pokemon[i][0] == lastchar)
                {
                    swap(ref pokemon[i], ref pokemon[len]);
                    Search(pokemon, longest_chain, len + 1);
                    swap(ref pokemon[i], ref pokemon[len]);
                }
            }
        }

        static void swap(ref string s1, ref string s2)
        {
            string tmp = s1;
            s1 = s2;
            s2 = tmp;
        }
    }
}
