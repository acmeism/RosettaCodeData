namespace RosettaCode.WordWrap
{
    using System;
    using System.Collections.Generic;

    internal static class Program
    {
        private const string LoremIpsum = @"
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas varius sapien
vel purus hendrerit vehicula. Integer hendrerit viverra turpis, ac sagittis arcu
pharetra id. Sed dapibus enim non dui posuere sit amet rhoncus tellus
consectetur. Proin blandit lacus vitae nibh tincidunt cursus. Cum sociis natoque
penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nam tincidunt
purus at tortor tincidunt et aliquam dui gravida. Nulla consectetur sem vel
felis vulputate et imperdiet orci pharetra. Nam vel tortor nisi. Sed eget porta
tortor. Aliquam suscipit lacus vel odio faucibus tempor. Sed ipsum est,
condimentum eget eleifend ac, ultricies non dui. Integer tempus, nunc sed
venenatis feugiat, augue orci pellentesque risus, nec pretium lacus enim eu
nibh.";

        private static void Main()
        {
            foreach (var lineWidth in new[] { 72, 80 })
            {
                Console.WriteLine(new string('-', lineWidth));
                Console.WriteLine(Wrap(LoremIpsum, lineWidth));
            }
        }

        private static string Wrap(string text, int lineWidth)
        {
            return string.Join(string.Empty,
                               Wrap(
                                   text.Split(new char[0],
                                              StringSplitOptions
                                                  .RemoveEmptyEntries),
                                   lineWidth));
        }

        private static IEnumerable<string> Wrap(IEnumerable<string> words,
                                                int lineWidth)
        {
            var currentWidth = 0;
            foreach (var word in words)
            {
                if (currentWidth != 0)
                {
                    if (currentWidth + word.Length < lineWidth)
                    {
                        currentWidth++;
                        yield return " ";
                    }
                    else
                    {
                        currentWidth = 0;
                        yield return Environment.NewLine;
                    }
                }
                currentWidth += word.Length;
                yield return word;
            }
        }
    }
}
