proc test {} {
    set header {
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                      ID                       |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |QR|   Opcode  |AA|TC|RD|RA|   Z    |   RCODE   |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    QDCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ANCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    NSCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
        |                    ARCOUNT                    |
        +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
    }

    set schema [asciipacket::parse $header]
    set values {
        ID 0xcafe
        QR 1
        Opcode 5
        AA 1
        TC 0
        RD 0
        RA 1
        Z  4
        RCODE 8
        QDCOUNT 0x00a5
        ANCOUNT 0x0a50
        NSCOUNT 0xa500
        ARCOUNT 0x500a
    }
    set pkt [asciipacket::encode $schema $values]
    puts "encoded packet (hex): [asciipacket::b2h $pkt]"
    array set decoded [asciipacket::decode $schema $pkt]
    parray decoded
}
test
