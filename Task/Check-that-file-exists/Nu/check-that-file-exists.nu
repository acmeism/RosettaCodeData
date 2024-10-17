['input.txt' 'doc' '/input.txt' '/doc'] | each { {file: $in exists: ($in | path exists)} }
