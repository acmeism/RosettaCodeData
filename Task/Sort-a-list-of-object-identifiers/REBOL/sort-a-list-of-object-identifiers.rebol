Rebol [
    title: "Rosetta code: Sort a list of object identifiers"
    file:  %Sort_a_list_of_object_identifiers.r3
    url:   https://rosettacode.org/wiki/Sort_a_list_of_object_identifiers
]

sort-oids: function[
    "Sorts a block of OID strings numerically using integer comparison."
    data [block!]
][
    ;; Convert each OID string to a block of integers (e.g. "1.3.6" → [1 3 6])
    data: sort map-each id data [replace/all id #"." SP transcode id]
    ;; Rejoin each integer block back into a dotted string (e.g. [1 3 6] → "1.3.6")
    data: map-each id data [ajoin/with id #"."]
    ;; Ensure each OID starts on a new line for readable output
    new-line/all data on
]

probe sort-oids [
   "1.3.6.1.4.1.11.2.17.19.3.4.0.10"
   "1.3.6.1.4.1.11.2.17.5.2.0.79"
   "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
   "1.3.6.1.4.1.11150.3.4.0.1"
   "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
   "1.3.6.1.4.1.11150.3.4.0"
]
