using System;
using System.IO;
using System.Collections.Generic;
using System.Runtime.Serialization.Formatters.Binary;

namespace Object_serialization
{
  [Serializable] public class Being
  {
    public bool Alive { get; set; }
  }

  [Serializable] public class Animal: Being
  {
    public Animal() { }

    public Animal(long id, string name, bool alive = true)
    {
      Id = id;
      Name = name;
      Alive = alive;
    }

    public long Id { get; set; }
    public string Name { get; set; }

    public void Print() { Console.WriteLine("{0}, id={1} is {2}",
      Name, Id, Alive ? "alive" : "dead"); }
  }


  internal class Program
  {
    private static void Main()
    {
      string path =
        Environment.GetFolderPath(Environment.SpecialFolder.Desktop)+"\\objects.dat";

      var n = new List<Animal>
              {
                new Animal(1, "Fido"),
                new Animal(2, "Lupo"),
                new Animal(7, "Wanda"),
                new Animal(3, "Kiki", alive: false)
              };

      foreach(Animal animal in n)
        animal.Print();

      using(var stream = new FileStream(path, FileMode.Create, FileAccess.Write))
        new BinaryFormatter().Serialize(stream, n);

      n.Clear();
      Console.WriteLine("---------------");
      List<Animal> m;

      using(var stream = new FileStream(path, FileMode.Open, FileAccess.Read))
        m = (List<Animal>) new BinaryFormatter().Deserialize(stream);

      foreach(Animal animal in m)
        animal.Print();
    }
  }
}
