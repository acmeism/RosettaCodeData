using System.Diagnostics;

var latitude = 51.433718m;
var longitude = -0.214126m;
Console.WriteLine(Geohash.Encode(latitude, longitude, 2));
var result = Geohash.Encode(latitude, longitude, 9);
Console.WriteLine(result);

for (var i = 0; i <= result.Length; i++)
{
    var prefix = result[..i];
    var (y0, dy, x0, dx, _) = Geohash.Decode(prefix);
    Console.WriteLine($"{prefix,9}: Latitude {y0} ± {dy}, Longitude {x0} ± {dx}");
    Debug.Assert(latitude >= y0 - dy);
    Debug.Assert(latitude < y0 + dy);
    Debug.Assert(longitude >= x0 - dx);
    Debug.Assert(longitude <= x0 + dx);
}

public static class Geohash
{
    const string code = "0145hjnp2367kmqr89destwxbcfguvyz";

    static readonly int[] decode = Index();

    static int[] Index()
    {
        var result = new int['z' + 1];
        Array.Fill(result, -1);

        for (var i = 0; i < code.Length; i++)
            result[code[i]] = i;

        return result;
    }

    public static string Encode(double latitude, double longitude, int precision) =>
        Encode((decimal)latitude, (decimal)longitude, precision);

    public static string Encode(decimal latitude, decimal longitude, int precision)
    {
        decimal xmin = -180, dx = 45, ymin = -90, dy = 45;
        System.Text.StringBuilder s = new();
        var horizontal = true;

        while (precision-- > 0)
        {
            var x = (int)((longitude - xmin) / dx);
            var y = (int)((latitude - ymin) / dy);
            xmin += x * dx;
            ymin += y * dy;

            if (horizontal)
            {
                s.Append(code[x + 8 * y]);
                dx /= 4;
                dy /= 8;
            }
            else
            {
                s.Append(code[y + 8 * x]);
                dx /= 8;
                dy /= 4;
            }

            horizontal ^= true;
        }

        return s.ToString();
    }

    public static (decimal latitudeCenter, decimal latitudeDelta,
                   decimal longitudeCenter, decimal lonDelta,
                   int precision) Decode(string geohash)
    {
        decimal xmin = -180, dx = 45, ymin = -90, dy = 45;
        var precision = 0;
        var horizontal = true;

        foreach (var c in geohash.ToLowerInvariant())
        {
            if (char.IsWhiteSpace(c))
                continue;

            if (c > decode.Length)
                throw new Exception(c.ToString());

            var d = decode[c];

            if (d == -1)
                throw new Exception(c.ToString());

            precision++;

            if (horizontal)
            {
                var (x, y) = (d % 8, d / 8);
                xmin += x * dx;
                ymin += y * dy;
                dx /= 4;
                dy /= 8;
                horizontal = false;
            }
            else
            {
                var (x, y) = (d / 8, d % 8);
                xmin += x * dx;
                ymin += y * dy;
                dx /= 8;
                dy /= 4;
                horizontal = true;
            }
        }

        // Remove trailing 0s (https://stackoverflow.com/a/7983330)
        static decimal z(decimal x) => x / 1.000000000000000000000000000000000m;

        if (horizontal)
            return (z(ymin + 2 * dy), z(dy * 2), z(xmin + 4 * dx), z(dx * 4), precision);
        else
            return (z(ymin + 4 * dy), z(dy * 4), z(xmin + 2 * dx), z(dx * 2), precision);
    }
}
