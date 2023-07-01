using System;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace MadLibs_RosettaCode
{
	class Program
	{
		static void Main(string[] args)
		{
			string madLibs =
@"Write a program to create a Mad Libs like story.
The program should read an arbitrary multiline story from input.
The story will be terminated with a blank line.
Then, find each replacement to be made within the story,
ask the user for a word to replace it with, and make all the replacements.
Stop when there are none left and print the final story.
The input should be an arbitrary story in the form:
<name> went for a walk in the park. <he or she>
found a <noun>. <name> decided to take it home.
Given this example, it should then ask for a name,
a he or she and a noun (<name> gets replaced both times with the same value).";

			StringBuilder sb = new StringBuilder();
			Regex pattern = new Regex(@"\<(.*?)\>");
			string storyLine;
			string replacement;

			Console.WriteLine(madLibs + Environment.NewLine + Environment.NewLine);
			Console.WriteLine("Enter a story: ");

			// Continue to get input while empty line hasn't been entered.
			do
			{
				storyLine = Console.ReadLine();
				sb.Append(storyLine + Environment.NewLine);
			} while (!string.IsNullOrEmpty(storyLine) && !string.IsNullOrWhiteSpace(storyLine));

			// Retrieve only the unique regex matches from the user entered story.
			Match nameMatch = pattern.Matches(sb.ToString()).OfType<Match>().Where(x => x.Value.Equals("<name>")).Select(x => x.Value).Distinct() as Match;
			if(nameMatch != null)
			{
				do
				{
					Console.WriteLine("Enter value for: " + nameMatch.Value);
					replacement = Console.ReadLine();
				} while (string.IsNullOrEmpty(replacement) || string.IsNullOrWhiteSpace(replacement));
				sb.Replace(nameMatch.Value, replacement);
			}

			foreach (Match match in pattern.Matches(sb.ToString()))
			{
				replacement = string.Empty;
				// Guarantee we get a non-whitespace value for the replacement
				do
				{
					Console.WriteLine("Enter value for: " + match.Value);
					replacement = Console.ReadLine();
				} while (string.IsNullOrEmpty(replacement) || string.IsNullOrWhiteSpace(replacement));

				int location = sb.ToString().IndexOf(match.Value);
				sb.Remove(location, match.Value.Length).Insert(location, replacement);
			}

			Console.WriteLine(Environment.NewLine + Environment.NewLine + "--[ Here's your story! ]--");
			Console.WriteLine(sb.ToString());
		}
	}
}
