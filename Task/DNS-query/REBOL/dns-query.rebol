Rebol [
    title: "Rosetta code: DNS query"
    file:  %DNS_query.r3
    url:   https://rosettacode.org/wiki/DNS_query
]

;; The following finds an IPv4 address.
;; Currently, the API does not support returning an IPv6 address.
foreach addr [8.8.8.8 "rosettacode.org"][
    printf [20 "-> "][ addr  read join dns:// addr ]
]
