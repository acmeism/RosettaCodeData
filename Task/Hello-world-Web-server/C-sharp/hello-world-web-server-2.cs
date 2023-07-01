namespace Webserver
{
  using System;
  using Nancy;
  using Nancy.Hosting.Self;

  public class HelloWorldModule : NancyModule
  {
    public HelloWorldModule()
    {
      this.Get["/"] = parameters => "Goodbye, world!";
    }

    public static void Main()
    {
      var uri = new Uri("http://localhost:8080");
      using (var host = new NancyHost(uri))
      {
        host.Start();
        Console.WriteLine("Web server is now running!");
        Console.WriteLine("Press 'Enter' to exit.");
        Console.ReadLine();
      }
    }
  }
}
