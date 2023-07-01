using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;

class Program
{
    static string CreateXML(Dictionary<string, string> characterRemarks)
    {
        var remarks = characterRemarks.Select(r => new XElement("Character", r.Value, new XAttribute("Name", r.Key)));
        var xml = new XElement("CharacterRemarks", remarks);
        return xml.ToString();
    }

    static void Main(string[] args)
    {
        var characterRemarks = new Dictionary<string, string>
        {
            { "April", "Bubbly: I'm > Tam and <= Emily" },
            { "Tam O'Shanter", "Burns: \"When chapman billies leave the street ...\"" },
            { "Emily", "Short & shrift" }
        };

        string xml = CreateXML(characterRemarks);
        Console.WriteLine(xml);
    }
}
