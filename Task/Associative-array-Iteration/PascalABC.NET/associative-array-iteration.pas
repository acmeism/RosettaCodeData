begin
  var zoo := new Dictionary<string,integer>;
  zoo['crocodile'] := 2;
  zoo['jiraffe'] := 3;
  zoo['behemoth'] := 1;
  foreach var kv in zoo do
    Println(kv.Key, kv.Value);
  Println;
  foreach var key in zoo.Keys do
    Println(key,zoo[key]);
end.
