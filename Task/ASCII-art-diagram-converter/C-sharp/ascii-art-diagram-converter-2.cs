var bytes = new byte[Header.MarshalledSize];
Random.Shared.NextBytes(bytes);
var header = Header.FromArray(bytes);
var bytes2 = header.ToArray();
Debug.Assert(Enumerable.SequenceEqual(bytes, bytes2));
Console.WriteLine($"Struct size: {Header.MarshalledSize} bytes");
Console.WriteLine($"Binary data: {string.Join(" ", bytes.Select(b => b.ToString("B8")))}");
Console.WriteLine($"Fields");

foreach (var (fname, fwidth) in fieldList)
{
    var value = typeof(Header).GetProperty(fname)!.GetValue(header);
    var vstr = $"{value!:B}".PadLeft(fwidth, '0');
    Console.WriteLine($"  {fname} = {vstr}");
}
