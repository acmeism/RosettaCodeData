##
uses System, System.Reflection;

var flags := BindingFlags.Instance or BindingFlags.Static
            or BindingFlags.Public or BindingFlags.DeclaredOnly;

typeof(integer).GetMethods(flags).PrintLines;
