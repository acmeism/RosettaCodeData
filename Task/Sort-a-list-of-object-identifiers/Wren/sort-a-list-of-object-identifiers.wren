import "/fmt" for Fmt
import "/sort" for Sort

var oids = [
    "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
    "1.3.6.1.4.1.11.2.17.5.2.0.79",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
    "1.3.6.1.4.1.11150.3.4.0.1",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
    "1.3.6.1.4.1.11150.3.4.0"
]

oids = oids.map { |oid| Fmt.v("s", 5, oid.split("."), 0, ".", "") }.toList
Sort.quick(oids)
oids = oids.map { |oid| oid.replace(" ", "") }.toList
System.print(oids.join("\n"))
