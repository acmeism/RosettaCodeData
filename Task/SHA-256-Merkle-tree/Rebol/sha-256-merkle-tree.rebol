Rebol [
    title: "Rosetta code: SHA-256 Merkle tree"
    file:  %SHA-256_Merkle_tree.r3
    url:    https://rosettacode.org/wiki/SHA-256_Merkle_tree
]

markle-tree: function/with [
    "Compute a Merkle Tree (hash tree) SHA-256 checksum"
    data [string! binary!] "source data"
    block-size [integer!]  "size of each leaf block in bytes"
][
    hashes: copy #{} ;; Binary buffer to store concatenated leaf hashes
    ;; Ensure data is binary for hashing
    unless binary? data [data: to binary! data]
    ;; Process data in block-size chunks
    while [not tail? data][
        ;; Append SHA hash of current chunk into 'hashes' binary
        ;; checksum/part <data> 'method <length> computes hash of segment
        append hashes checksum/part data 'sha256 block-size
        ;; Advance input cursor by one block
        data: skip data block-size
    ]
    ;; Build the Merkle root from the concatenated leaf hashes
    compute-tree-hash hashes
][
    ;; Helper function: Recursively reduce a binary containing concatenated hashes
    ;; until a single hash remains (the Merkle root).
    compute-tree-hash: func [
        hashes [binary!]   ;; Current level's concatenated hashes
        /local next-level
    ][
        ;; If only one hash remains (32 bytes for SHA-256), we are done
        either 32 == length? hashes [
            hashes
        ][
            next-level: copy #{}  ;; Binary accumulator for next level
            ;; Process the current level in pairs of hashes (2 × 32 bytes = 64 bytes)
            while [not tail? hashes] [
                append next-level either 64 > length? hashes [
                    ;; Odd-last hash is promoted unchanged when no pair to combine
                    hashes
                ][
                    ;; Otherwise, concatenate two 32-byte hashes (already together
                    ;; in the first 64 bytes) and hash them to form parent node
                    checksum/part hashes 'sha256 64
                ]

                ;; Move to the next hash or next pair
                hashes: skip hashes 64
            ]
            ;; Recurse to continue building tree until one root hash remains
            compute-tree-hash next-level
        ]
    ]
]

;; Display the Merkle root hash (as binary) for "abcdef" using 2-byte leafs
assert [
    #{ECE0D575751F0CE6D4829D1EE93916B993CC9D5F41D4F59AC6BB5340F5F6F903}
    == probe markle-tree "abcdef" 2
]

;; Using the image from the task specification:
image-url: https://github.com/thundergnat/rc-run/blob/master/rc/resources/title.png?raw=true
assert [
    not error? bin: try [read image-url]
    #{A4F902CF9D51FE51EDA156A6792E1445DFF65EDF3A217A1F3334CC9CF1495C2C}
    == probe markle-tree :bin 1024
]
