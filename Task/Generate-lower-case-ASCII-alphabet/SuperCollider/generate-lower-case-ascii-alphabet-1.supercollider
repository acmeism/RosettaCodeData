(97..122).asAscii; // This example unfortunately throws an error
                   // for me when running it on version 3.10.2

// Apparently, the message 'asAscii' cannot be understood by
// an Array, so I used the message 'collect' to apply the function
// enclosed in {} to each individual element of the Array,
// passing them the message 'asAscii':

(97..122).collect({|asciiCode| asciiCode.asAscii});

// Instead of writing the ascii codes directly as numbers,
// one could also pass the chars a and z the message 'ascii' to convert
// them to ascii codes – perhaps making the code a bit clearer:

($a.ascii..$z.ascii).collect({|asciiCode| asciiCode.asAscii});

// both examples output [ a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z ]
