using System;
using System.Collections.Generic;
using System.Text;

public static class CamelCaseAndSnakeCase
{
    public static void Main(string[] args)
    {
        List<string> variableNames = new List<string>
        {
            "snakeCase", "snake_case", "variable_10_case", "variable10Case",
            "ergo rE tHis", "hurry-up-joe!", "c://my-docs/happy_Flag-Day/12.doc", "  spaces  "
        };

        Console.WriteLine($"{"=== To snake_case ===",48}");
        foreach (string text in variableNames)
        {
            Console.WriteLine($"{text,34} --> {ToSnakeCase(text)}");
        }

        Console.WriteLine();
        Console.WriteLine($"{"=== To camelCase ===",48}");
        foreach (string text in variableNames)
        {
            Console.WriteLine($"{text,34} --> {ToCamelCase(text)}");
        }
    }

    private static string ToSnakeCase(string aCamel)
    {
        aCamel = aCamel.Trim().Replace(SPACE, UNDERSCORE).Replace(HYPHEN, UNDERSCORE);
        StringBuilder snake = new StringBuilder();
        bool first = true;
        foreach (char ch in aCamel)
        {
            if (first)
            {
                snake.Append(ch);
                first = false;
            }
            else if (!first && char.IsUpper(ch))
            {
                if (snake.ToString().EndsWith(UNDERSCORE))
                {
                    snake.Append(char.ToLower(ch));
                }
                else
                {
                    snake.Append(UNDERSCORE + char.ToLower(ch));
                }
            }
            else
            {
                snake.Append(ch);
            }
        }
        return snake.ToString();
    }

    private static string ToCamelCase(string aSnake)
    {
        aSnake = aSnake.Trim().Replace(SPACE, UNDERSCORE).Replace(HYPHEN, UNDERSCORE);
        StringBuilder camel = new StringBuilder();
        bool underscore = false;
        foreach (char ch in aSnake)
        {
            if (ch.ToString().Equals(UNDERSCORE))
            {
                underscore = true;
            }
            else if (underscore)
            {
                camel.Append(char.ToUpper(ch));
                underscore = false;
            }
            else
            {
                camel.Append(ch);
            }
        }
        return camel.ToString();
    }

    private static readonly string SPACE = " ";
    private static readonly string UNDERSCORE = "_";
    private static readonly string HYPHEN = "-";
}
