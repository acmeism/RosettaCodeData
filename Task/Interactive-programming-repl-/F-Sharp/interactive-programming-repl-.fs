Microsoft F# Interactive, (c) Microsoft Corporation, All Rights Reserved
F# Version 1.9.6.2, compiling for .NET Framework Version v2.0.50727

Please send bug reports to fsbugs@microsoft.com
For help type #help;;

> let f a b sep = String.concat sep [a; ""; b] ;;

val f : string -> string -> string -> string

> f "Rosetta" "Code" ":" ;;
val it : string = "Rosetta::Code"
