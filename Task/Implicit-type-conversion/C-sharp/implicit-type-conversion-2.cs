public class Person
{
    //Define an implicit conversion from string to Person
    public static implicit operator Person(string name) => new Person { Name = name };

    public string Name { get; set; }
    public override string ToString() => $"Name={Name}";

    public static void Main() {
        Person p = "Mike";
        Console.WriteLine(p);
    }
}
