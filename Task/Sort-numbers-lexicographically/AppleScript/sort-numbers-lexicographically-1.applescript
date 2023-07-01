on oneToNLexicographically(n)
    script o
        property output : {}

        on otnl(i)
            set j to i + 9 - i mod 10
            if (j > n) then set j to n
            repeat with i from i to j
                set end of my output to i
                tell i * 10 to if (it ≤ n) then my otnl(it)
            end repeat
        end otnl
    end script

    o's otnl(1)

    return o's output
end oneToNLexicographically

-- Test code:
oneToNLexicographically(13)
--> {1, 10, 11, 12, 13, 2, 3, 4, 5, 6, 7, 8, 9}

oneToNLexicographically(123)
--> {1, 10, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 11, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 12, 120, 121, 122, 123, 13, 14, 15, 16, 17, 18, 19, 2, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 3, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 4, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 5, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 6, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 7, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 8, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 9, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99}
