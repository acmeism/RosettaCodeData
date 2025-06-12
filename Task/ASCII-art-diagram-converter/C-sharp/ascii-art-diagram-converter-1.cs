using System.CodeDom.Compiler;
using System.Diagnostics;

var format = @"+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                      ID                       |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    QDCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ANCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    NSCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
|                    ARCOUNT                    |
+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+";

var lines = format.Split('\n')
    .Select(line => line.Trim())
    .Where(s => s.Length > 0)
    .ToArray();

var first = lines[0];
var ll = first.Length;

if (lines.Any(line => line.Length != ll))
    throw new Exception("Lines are not the same length.");

if (first[0] != '+' || first[^1] != '+')
    throw new Exception("First line does not start and end with '+'.");

var bits = first.Split('+')[1..^1];

if (bits.Any(bit => bit != "--"))
    throw new Exception("Not all bits on first line match '+--+'.");

if (lines.Length % 2 == 0)
    throw new Exception("Expected an odd number of definition lines.");

var rows = lines.Length / 2;

if (Enumerable.Range(0, rows).Any(row => lines[2 * row + 2] != first))
    throw new Exception("Not all line separators match first line.");

var width = bits.Length;

if (width != 8 && width != 16 && width != 32 && width != 64)
    throw new Exception("Bit width is not 8, 16, 32, or 64.");

var ftype = width switch
{
    8 => "byte",
    16 => "ushort",
    32 => "uint",
    _ => "ulong"
};

const string filename = "Header.cs";
const string structName = "Header";
List<(string Name, int Width)> fieldList = [];
List<string> backing = [];

using (var file = File.CreateText(filename))
using (var code = new IndentedTextWriter(file))
{
    code.WriteLine("using System.Buffers.Binary;");
    code.WriteLine("using System.Runtime.InteropServices;");
    code.WriteLine();
    code.WriteLine("[StructLayout(LayoutKind.Sequential, Pack = 0)]");
    code.WriteLine($"public struct {structName}");
    code.WriteLine("{");
    code.Indent++;
    code.WriteLine($"public static readonly int MarshalledSize = Marshal.SizeOf<{structName}>();");

    for (var row = 0; row < rows; row++)
    {
        var def = lines[row * 2 + 1];

        if (def[0] != '|' || def[^1] != '|')
            throw new Exception($"Row {row} doesn't start and end with '|'.");

        var fields = def.Split('|')[1..^1];

        if (fields.Length > 1)
        {
            code.WriteLine();
            code.WriteLine($"{ftype} data{row};");
            backing.Add($"data{row}");
        }

        var offset = width;

        foreach (var field in fields)
        {
            if (field.Length % 3 != 2)
                throw new Exception($"Field '{field.Trim()}' delimiters misaligned.");

            var fname = field.Trim();

            if (fname.Length == 0)
                throw new Exception($"Field name is missing.");

            var fwidth = (field.Length + 1) / 3;
            offset -= fwidth;
            fieldList.Add((fname, fwidth));
            var mask = "0b" + new string('1', fwidth);
            var nmask = "0b" + new string('1', width - fwidth - offset) + new string('0', fwidth) + new string('1', offset);
            code.WriteLine();
            code.WriteLine($"public {ftype} {fname}");
            code.WriteLine("{");
            code.Indent++;

            if (fields.Length == 1)
            {
                code.WriteLine("readonly get;");
                code.WriteLine("set;");
                backing.Add(fname);
            }
            else
            {
                code.WriteLine($"readonly get {{ return ({ftype})((data{row} >> {offset}) & {mask});}}");
                code.WriteLine($"set {{ data{row} = ({ftype})((data{row} & {nmask}) | ((value & {mask}) << {offset})); }}");
            }

            code.Indent--;
            code.WriteLine("}");
        }
    }

    code.WriteLine();
    code.WriteLine($"public static {structName} FromArray(byte[] bytes)");
    code.WriteLine("{");
    code.Indent++;
    code.WriteLine("var handle = GCHandle.Alloc(bytes, GCHandleType.Pinned);");
    code.WriteLine($"var result = Marshal.PtrToStructure<{structName}>(handle.AddrOfPinnedObject());");
    code.WriteLine("handle.Free();");

    if (width > 8)
    {
        code.WriteLine();
        code.WriteLine("if (BitConverter.IsLittleEndian)");
        code.WriteLine("{");
        code.Indent++;

        foreach (var f in backing)
        {
            code.WriteLine($"result.{f} = BinaryPrimitives.ReverseEndianness(result.{f});");
        }

        code.Indent--;
        code.WriteLine("}");
        code.WriteLine();
    }

    code.WriteLine("return result;");
    code.Indent--;
    code.WriteLine("}");
    code.WriteLine();
    code.WriteLine("public readonly byte[] ToArray()");
    code.WriteLine("{");
    code.Indent++;
    code.WriteLine($"var bytes = new byte[Marshal.SizeOf<{structName}>()];");
    code.WriteLine("var handle = GCHandle.Alloc(bytes, GCHandleType.Pinned);");
    code.WriteLine("Marshal.StructureToPtr(this, handle.AddrOfPinnedObject(), false);");
    code.WriteLine("handle.Free();");

    if (width > 8)
    {
        code.WriteLine();
        code.WriteLine("if (BitConverter.IsLittleEndian)");
        code.WriteLine("{");
        code.Indent++;
        code.WriteLine($"for (var i = 0; i < MarshalledSize; i += sizeof({ftype}))");
        code.WriteLine("{");
        code.Indent++;
        code.WriteLine($"Array.Reverse(bytes, i, sizeof({ftype}));");
        code.Indent--;
        code.WriteLine("}");
        code.Indent--;
        code.WriteLine("}");
        code.WriteLine();
    }

    code.WriteLine("return bytes;");
    code.Indent--;
    code.WriteLine("}");

    code.Indent--;
    code.WriteLine("}");
}
