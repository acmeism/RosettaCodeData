import "./upc" for Graphemes

System.print(Graphemes.clusterCount("møøse"))
System.print(Graphemes.clusterCount("𝔘𝔫𝔦𝔠𝔬𝔡𝔢"))
var jose = "J\u0332o\u0332s\u0332e\u0301\u0332"
System.print(Graphemes.clusterCount(jose))
