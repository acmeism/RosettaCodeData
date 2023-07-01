using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Rosetta.CheckPointSync;

public class Program
{
    public async Task Main()
    {
        RobotBuilder robotBuilder = new RobotBuilder();
        Task work = robotBuilder.BuildRobots(
            "Optimus Prime", "R. Giskard Reventlov", "Data", "Marvin",
            "Bender", "Number Six", "C3-PO", "Dolores");
        await work;
    }

    public class RobotBuilder
    {
        static readonly string[] parts = { "Head", "Torso", "Left arm", "Right arm", "Left leg", "Right leg" };
        static readonly Random rng = new Random();
        static readonly object key = new object();

        public Task BuildRobots(params string[] robots)
        {
            int r = 0;
            Barrier checkpoint = new Barrier(parts.Length, b => {
                Console.WriteLine($"{robots[r]} assembled. Hello, {robots[r]}!");
                Console.WriteLine();
                r++;
            });
            var tasks = parts.Select(part => BuildPart(checkpoint, part, robots)).ToArray();
            return Task.WhenAll(tasks);
        }

        private static int GetTime()
        {
            //Random is not threadsafe, so we'll use a lock.
            //There are better ways, but that's out of scope for this exercise.
            lock (key) {
                return rng.Next(100, 1000);
            }
        }

        private async Task BuildPart(Barrier barrier, string part, string[] robots)
        {
            foreach (var robot in robots) {
                int time = GetTime();
                Console.WriteLine($"Constructing {part} for {robot}. This will take {time}ms.");
                await Task.Delay(time);
                Console.WriteLine($"{part} for {robot} finished.");
                barrier.SignalAndWait();
            }
        }

    }

}
