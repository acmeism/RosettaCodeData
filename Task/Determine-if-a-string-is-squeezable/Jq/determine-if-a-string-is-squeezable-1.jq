# Assume $c is specified as a single character correctly
def squeeze($c): gsub("[\($c)]+"; $c);

def Guillemets: "«««\(.)»»»";

def Squeeze(s; $c):
  "Squeeze character: \($c)",
   (s | "Original: \(Guillemets) has length \(length)",
        (squeeze($c) | "result is \(Guillemets) with length \(length)")),
   "";
