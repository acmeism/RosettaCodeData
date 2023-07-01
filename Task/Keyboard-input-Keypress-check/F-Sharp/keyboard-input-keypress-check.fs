open System;

let chr = if Console.KeyAvailable then Console.ReadKey().Key.ToString() else String.Empty
