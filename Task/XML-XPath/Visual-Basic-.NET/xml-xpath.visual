Dim first_item = xml.XPathSelectElement("//item")
Console.WriteLine(first_item)

For Each price In xml.XPathSelectElements("//price")
    Console.WriteLine(price.Value)
Next

Dim names = (From item In xml.XPathSelectElements("//name") Select item.Value).ToArray
