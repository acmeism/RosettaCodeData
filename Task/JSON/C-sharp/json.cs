using System;
using System.Collections.Generic;
using System.Web.Script.Serialization;

class Program
{
    static void Main()
    {
        var people = new Dictionary<string, object> {{"1", "John"}, {"2", "Susan"}};
        var serializer = new JavaScriptSerializer();

        var json = serializer.Serialize(people);
        Console.WriteLine(json);

        var deserialized = serializer.Deserialize<Dictionary<string, object>>(json);
        Console.WriteLine(deserialized["2"]);

        var jsonObject = serializer.DeserializeObject(@"{ ""foo"": 1, ""bar"": [10, ""apples""] }");
        var data = jsonObject as Dictionary<string, object>;
        var array = data["bar"] as object[];
        Console.WriteLine(array[1]);
    }
}
