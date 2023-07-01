|ptr|
ptr := ExternalBytes new:10.
ptr address.
ptr byteAt:1 put: 16rFF.
