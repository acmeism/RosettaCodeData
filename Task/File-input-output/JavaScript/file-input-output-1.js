var fso = new ActiveXObject("Scripting.FileSystemObject");
var ForReading = 1, ForWriting = 2;
var f_in = fso.OpenTextFile('input.txt', ForReading);
var f_out = fso.OpenTextFile('output.txt', ForWriting, true);

// for small files:
// f_out.Write( f_in.ReadAll() );

while ( ! f_in.AtEndOfStream) {
    // ReadLine() does not include the newline char
    f_out.WriteLine( f_in.ReadLine() );
}

f_in.Close();
f_out.Close();
