var prevIdle = 0f;
var prevTotal = 0f;

while (true)
{
    var cpuLine = File
        .ReadAllLines("/proc/stat")
        .First()
        .Split(' ', StringSplitOptions.RemoveEmptyEntries)
        .Skip(1)
        .Select(float.Parse)
        .ToArray();

    var idle = cpuLine[3];
    var total = cpuLine.Sum();

    var percent = 100.0 * (1.0 - (idle - prevIdle) / (total - prevTotal));
    Console.WriteLine($"{percent:0.00}%");

    prevIdle = idle;
    prevTotal = total;

    Thread.Sleep(1000);
}
