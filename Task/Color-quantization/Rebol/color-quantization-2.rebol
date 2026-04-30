Rebol [
    title: "Rosetta code: Color quantization (Octree)"
    file:  %Color_quantization-octree.r3
    url:   https://rosettacode.org/wiki/Color_quantization
]

octree-quantize: function/with [
    img [image! file! url!]
    n-colors [integer!]
][
    unless image? img [img: load img]
    quantizer: make-octree-quantizer

    ;; Downsample to 25% of pixels for tree building - dramatically faster with
    ;; minimal palette quality loss since distribution is well represented by a sample
    sm-img: resize/filter img 25% 'box

    ;; First pass - count color frequencies
    freq: make map! 32768
    foreach color sm-img [
        freq/:color: either p: freq/:color [p + 1][1]
    ]
    ;; Second pass - only add frequent colors to the octree
    foreach color sm-img [
        if freq/:color > 1 [
            add-color quantizer color
        ]
    ]

    palette: make-palette quantizer n-colors

    ;; Map each pixel to its nearest palette color.
    forall img [
        idx: get-palette-index quantizer img/1
        img/1: palette/:idx
    ]

    reduce [img palette]
][
    ;; Maximum octree depth - at depth 8 each node represents a unique 24-bit color
    ;; (8 bits per channel, one bit inspected per level)
    make-octree-node: func [level parent /local node] [
        node: object [
            ;; Accumulated channel sums and pixel count for average color calculation
            red: green: blue: pixel-count: 0
            palette-index: 0   ;; assigned during make-palette
            children: array 8  ;; up to 8 children, one per RGB bit at this level
        ]
        ;; Leaf-level nodes (level 7) are not registered since they won't be merged
        if level < 7 [
            add-level-node parent level node
        ]
        node
    ]

    ; Iteratively collect all leaf nodes (nodes with pixel-count > 0) under `node`
    get-leaf-nodes: function [node] [
        leaf-nodes: copy []
        stack: clear []
        foreach child node/children [
            if child [append stack child]
        ]
        while [not empty? stack] [
            current: take stack
            either current/pixel-count > 0 [
                append leaf-nodes current
            ][
                foreach child current/children [
                    if child [append stack child]
                ]
            ]
        ]
        leaf-nodes
    ]

    ;; Walk the tree to find the palette index assigned to `color`.
    ;; At a leaf, return its index. Otherwise, compute which child to descend into
    ;; by extracting one bit per channel at the current level to form a 3-bit index.
    ;; If the exact child was pruned during palette reduction, fall back to the first
    ;; available sibling.
    get-palette-index-for-color: function [node color level] [
        ; Walk the tree iteratively until we reach a leaf (pixel-count > 0)
        while [node/pixel-count = 0] [
            index: 1
            mask: 128 >> level
            unless zero? color/1 & mask [index: index + 4]  ; bit 2
            unless zero? color/2 & mask [index: index + 2]  ; bit 1
            unless zero? color/3 & mask [index: index + 1]  ; bit 0
            ++ level
            ;; If exact child was pruned, fall back to first available child
            either node/children/:index [
                node: node/children/:index
            ][
                foreach child node/children [
                    if child [node: child  break]
                ]
            ]
        ]
        node/palette-index
    ]

    ;; Merge all children of `node` into the node itself, making it a leaf.
    ;; Accumulates children's color sums and pixel counts into the parent.
    ;; Returns the net reduction in leaf count: (number of children merged) - 1,
    ;; because the parent itself becomes a new leaf.
    remove-leaves: function [node] [
        result: 0
        foreach child node/children [
            if child [
                node/red:   node/red   + child/red
                node/green: node/green + child/green
                node/blue:  node/blue  + child/blue
                node/pixel-count: node/pixel-count + child/pixel-count
                ++ result
            ]
        ]
        result - 1
    ]

    ;; Compute the average color for a leaf node by dividing accumulated
    ;; channel sums by the total pixel count
    get-color: func [node] [
        make tuple! reduce [
            node/red   / node/pixel-count
            node/green / node/pixel-count
            node/blue  / node/pixel-count
        ]
    ]

    get-pixel-count: func [node] [
        result: 0
        stack: clear []
        foreach child node/children [if child [append stack child]]
        while [not empty? stack] [
            if current: take stack [
                either current/pixel-count > 0 [
                    result: result + current/pixel-count
                ][
                    append stack current/children
                ]
            ]
        ]
        result
    ]

    ;; Create and initialise a new octree quantizer.
    ;; `levels` holds one block of nodes per depth level, used during palette reduction.
    ;; `leaf-count` tracks the current number of leaves without requiring a tree walk.
    make-octree-quantizer: func [/local quantizer] [
        quantizer: context [
            levels:     array/initial 8 []
            root:       none
            leaf-count: 0
            ;; caches:
            color-node:  make map! 16384
            color-index: make map! 65536
        ]
        quantizer/root: make-octree-node 0 quantizer
        quantizer
    ]

    ;; Register `node` at `level` in the quantizer so it can be found during reduction
    add-level-node: func [quantizer level node] [
        append (pickz quantizer/levels level) node
    ]

    get-leaves: func [quantizer] [
        get-leaf-nodes quantizer/root
    ]

    ;; Add `color` to the octree. Uses color-node cache to skip tree
    ;; traversal for already-seen colors, only walking the tree on first
    ;; encounter of each unique color. At each level, a 3-bit index derived
    ;; from one bit per RGB channel selects the child. A new leaf is counted
    ;; the first time a node receives a pixel at max depth.
    add-color: function [quantizer color [tuple!]] [
        unless node: quantizer/color-node/:color [
            ;; First time seeing this color - traverse/build the tree path
            node: quantizer/root
            level: 0
            while [level < 8] [
                index: 1
                mask: 128 >> level
                unless zero? color/1 & mask [index: index + 4]
                unless zero? color/2 & mask [index: index + 2]
                unless zero? color/3 & mask [index: index + 1]
                unless node/children/:index [
                    node/children/:index: make-octree-node level quantizer
                ]
                node: node/children/:index
                ++ level
            ]
            ;; Count new leaf (pixel-count = 0 means this node hasn't been seen before)
            if all [
                node/pixel-count = 0
                level >= 8
            ][  quantizer/leaf-count: quantizer/leaf-count + 1 ]
            ;; Cache the node so future occurrences of this color skip the traversal
            quantizer/color-node/:color: node
        ]
        ;; Accumulate color data regardless of cache hit or miss
        node/red:   node/red   + color/1
        node/green: node/green + color/2
        node/blue:  node/blue  + color/3
        node/pixel-count: node/pixel-count + 1
    ]

    ;; Build a palette of at most `color-count` colors by reducing the octree bottom-up.
    ;; Iterates levels from deepest to shallowest, merging sibling leaves into their
    ;; parent until the leaf count fits within the target. Then assigns palette
    ;; indices to remaining leaves and records their average colors.
    make-palette: function [quantizer color-count] [
        palette: copy []
        palette-index: 0
        leaf-count: quantizer/leaf-count
        for level-index 8 1 -1 [
            level-nodes: quantizer/levels/:level-index
            unless empty? level-nodes [
                foreach node level-nodes [
                    if leaf-count <= color-count [break]
                    ;; count how many children this node has (= reduction + 1)
                    children-count: 0
                    foreach child node/children [if child [++ children-count]]
                    if (leaf-count - children-count + 1) >= color-count [
                        leaf-count: leaf-count - (remove-leaves node)
                    ]
                ]
                if leaf-count <= color-count [break]
                quantizer/levels/:level-index: copy []
            ]
        ]
        ;; Assign palette indices to remaining leaves and record their average colors
        foreach node get-leaves quantizer [
            if palette-index >= color-count [break]
            if node/pixel-count > 0 [append palette get-color node]
            node/palette-index: palette-index
            ++ palette-index
        ]
        palette
    ]

    ;; Look up the palette index for `color` by traversing the (possibly reduced) tree
    get-palette-index: function [quantizer color] [
        unless index: quantizer/color-index/:color [
            quantizer/color-index/:color: index:
                get-palette-index-for-color quantizer/root color 0
        ]
        index + 1
    ]
]

;; Download the original image if does not exists.
unless exists? %Quantum_frog.png [
    write %quantum_frog.png
     read https://static.wikitide.net/rosettacodewiki/3/3f/Quantum_frog.png
]

foreach [colors output-name] [
    16 %Quantum_frog-octree-16-colors.png
    32 %Quantum_frog-octree-32-colors.png
][
    ;; Quantize to N colors
    time: delta-time [
        set [img colors] octree-quantize %Quantum_frog.png colors
    ]
    print ["Time to compute:" time]
    ;; Display all used colors
    print ["The" length? colors "colors used:"]
    probe new-line/all colors true
    save output-name img  ;; Save the result
    browse output-name    ;; Display the image in a browser
]
