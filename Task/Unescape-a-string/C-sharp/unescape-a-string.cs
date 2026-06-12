using System;
using System.Collections.Generic;
using System.Text;

public class UnescapeAString
{
    public static void Main(string[] args)
    {
        var tests = new List<string>
        {
            "abc", "a☺c", "a\\\"c", "\\u0061\\u0062\\u0063", "a\\\\c",
            "a\\u263Ac", "a\\\\u263Ac", "a\\uD834\\uDD1Ec", "a\\ud834\\udd1ec",
            "a\\u263", "a\\u263Xc", "a\\uDD1Ec", "a\\uD834c", "a\\uD834\\u263Ac"
        };

        foreach (string test in tests)
        {
            try
            {
                string result = UnescapeJSONString(test);
                Console.WriteLine($"{test} => {result}");
            }
            catch (UnescapeException exception)
            {
                Console.WriteLine($"{test} => {exception.Message}");
            }
        }
    }

    private static string UnescapeJSONString(string text)
    {
        var result = new StringBuilder();
        int index = 0;

        while (index < text.Length)
        {
            char ch = text[index];

            if (ch == '\\')
            {
                if (index < text.Length - 1)
                {
                    index += 1;
                    ch = text[index];
                }
                else
                {
                    throw new UnescapeException("Invalid escape sequence");
                }

                switch (ch)
                {
                    case '\"':
                        result.Append("\"");
                        break;
                    case '\\':
                        result.Append("\\");
                        break;
                    case '/':
                        result.Append("/");
                        break;
                    case 'b':
                        result.Append("\b");
                        break;
                    case 'f':
                        result.Append("\f");
                        break;
                    case 'n':
                        result.Append("\n");
                        break;
                    case 'r':
                        result.Append("\r");
                        break;
                    case 't':
                        result.Append("\t");
                        break;
                    case 'u':
                        {
                            int startIndex = index - 1;
                            var decodeResult = DecodeHexChar(text, index);
                            if (decodeResult.CodePoint == -1)
                            {
                                return result.ToString();
                            }
                            result.Append(StringFromCodePoint(decodeResult.CodePoint, startIndex));
                            index = decodeResult.Index;
                            break;
                        }
                    default:
                        throw new UnescapeException("Unknown character");
                }
            }
            else
            {
                result.Append(ch);
            }
            index += 1;
        }
        return result.ToString();
    }

    private static DecodeResult DecodeHexChar(string text, int index)
    {
        if (index >= text.Length - 4)
        {
            throw new UnescapeException("Incomplete escape sequence");
        }

        index += 1;
        int codepoint = ParseHexDigits(text.Substring(index, 4), index - 2);

        if (IsLowSurrogate(codepoint))
        {
            throw new UnescapeException("Lone low surrogate");
        }

        if (IsHighSurrogate(codepoint))
        {
            if (!(index < text.Length - 9 &&
                text[index + 4] == '\\' && text[index + 5] == 'u'))
            {
                throw new UnescapeException("Lone high surrogate");
            }

            int lowSurrogate = ParseHexDigits(text.Substring(index + 6, 4), index + 4);
            if (!IsLowSurrogate(lowSurrogate))
            {
                throw new UnescapeException("High surrogate followed by a non-surrogate");
            }

            codepoint = 0x10000 + (((codepoint & 0x03ff) << 10) | (lowSurrogate & 0x03ff));
            return new DecodeResult(codepoint, index + 9);
        }

        return new DecodeResult(codepoint, index + 3);
    }

    private static int ParseHexDigits(string digits, int index)
    {
        int codepoint = 0;
        foreach (char digit in digits)
        {
            codepoint <<= 4;
            if (digit >= '0' && digit <= '9')
            {
                codepoint |= (digit - '0');
            }
            else if (digit >= 'A' && digit <= 'F')
            {
                codepoint |= (digit - 'A' + 10);
            }
            else if (digit >= 'a' && digit <= 'f')
            {
                codepoint |= (digit - 'a' + 10);
            }
            else
            {
                throw new UnescapeException("Invalid hexadecimal digit");
            }
        }
        return codepoint;
    }

    private static bool IsLowSurrogate(int i) => i >= 0xdc00 && i <= 0xdfff;
    private static bool IsHighSurrogate(int i) => i >= 0xd800 && i <= 0xdbff;

    private static string StringFromCodePoint(int codepoint, int index)
    {
        if (codepoint > 0x10ffff || codepoint <= 0x1f)
        {
            throw new UnescapeException("Invalid character");
        }
        return char.ConvertFromUtf32(codepoint);
    }

    private class DecodeResult
    {
        public int CodePoint { get; }
        public int Index { get; }

        public DecodeResult(int codePoint, int index)
        {
            CodePoint = codePoint;
            Index = index;
        }
    }
}

public class UnescapeException : Exception
{
    public UnescapeException(string message) : base(message)
    {
    }
}
