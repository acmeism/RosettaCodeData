// read entire file into variable using default system encoding or with specified encoding
open System.IO
let data = File.ReadAllText(filename)
let utf8 = File.ReadAllText(filename, System.Text.Encoding.UTF8)
