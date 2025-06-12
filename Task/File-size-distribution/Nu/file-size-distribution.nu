 [d:/work d:/drivers d:/images ] | each { ls ($"($in)/**/*" | into glob) |
  each { |it|
    let size = ($it.size | into int)
    {
        name: $it.name
        size: $size
        SizeCategory: (match $size {
            0..1_000 => "Under 1 KB"
            1_001..5_000 => "1 KB 5 KB"
            5_001..10_000 => "5 KB 10 KB"
            10_001..25_000 => "10 KB to  25 KB"
            25_001..50_000 => "25 KB to 50 KB"
            50_001..1_000_000 => "50 KB to  1 MB"
            1_000_001..5_000_000 => "1 MB to 5 MB"
            5_000_001..10_000_000 => "5 MB to 10 MB"
            10_000_001..25_000_000 => "10 MB to 25 MB"
            25_000_001..50_000_000 => "25 MB to 50 MB"
            50_000_001..100_000_000 => "50 MB to 100 MB"
            100_000_001..500_000_000 => "100 MB to 500 MB"
            500_000_001..1_000_000_000 => "500 MB to 1 GB"
            1_000_000_001..3_000_000_000 => "1 GB to 3 GB"
            _ => "Over 3 GB"
        })
    } } } | flatten | histogram SizeCategory
