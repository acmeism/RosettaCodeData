{$reference System.Web.Extensions.dll}
uses System.Web.Script.Serialization;

begin
  var serializer := new JavaScriptSerializer;
  var people := new Dictionary<string, object>;
  people.Add('1', 'John');
  people.Add('2', 'Susan');
  var json := serializer.Serialize(people);
  Println(json);
  var res := serializer.Deserialize&<Dictionary<string, object>>(json);
  Println(TypeName(res));
  Println(res);

  var jsonObject := serializer.DeserializeObject('{ "foo": 1, "bar": [10, "apples"] }')
    as Dictionary<string, object>;
  Println(jsonObject);
  var arr := jsonObject['bar'] as array of object;
  arr.Println;
end.
