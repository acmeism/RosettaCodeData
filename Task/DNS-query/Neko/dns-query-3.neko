(define (dnsLookup site , ipv)
    ;; captures current IPv mode
    (set 'ipv (net-ipv))
    ;; IPv mode agnostic lookup
    (println "IPv4: " (begin (net-ipv 4) (net-lookup site)))
    (println "IPv6: " (begin (net-ipv 6) (net-lookup site)))
    ;; returns newLISP to previous IPv mode
    (net-ipv ipv)
)

(dnsLookup "www.kame.net")
