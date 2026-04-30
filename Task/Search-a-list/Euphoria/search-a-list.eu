include std/search.e
include std/console.e

--the string "needle" and example haystacks to test the procedure
sequence searchStr1 = "needle"
sequence haystack1 = { "needle", "needle", "noodle", "node", "need", "needle  ", "needle" }
sequence haystack2 = {"spoon", "fork", "hay", "knife", "needle", "barn", "etcetera", "more hay", "needle", "a cow", "farmer", "needle", "dirt"}
sequence haystack3 = {"needle"}
sequence haystack4 = {"no", "need le s", "in", "this", "haystack"}
sequence haystack5 = {"knee", "needle", "dull", "needle"}
sequence haystack6 = {}

--search procedure with console output
procedure haystackSearch(sequence hStack)
    sequence foundNeedles = find_all(searchStr1, hStack)
    puts(1,"---------------------------------\r\n")
    if object(foundNeedles) and length(foundNeedles) > 0 then
        printf(1, "First needle found at index %d \r\n", foundNeedles[1])

        if length(foundNeedles) > 1 then
            printf(1, "Last needle found at index %d \r\n", foundNeedles[length(foundNeedles)] )

            for i = 1 to length(foundNeedles) do
                printf(1, "Needle #%d ", i)
                printf(1, "was at index %d .\r\n", foundNeedles[i])
            end for

            else
                puts(1, "There was only one needle found in this haystack. \r\n")
        end if

        else
            puts(1, "Simulated exception - No needles found in this haystack.\r\n")
    end if

end procedure

--runs the procedure on all haystacks
haystackSearch(haystack1)
haystackSearch(haystack2)
haystackSearch(haystack3)
haystackSearch(haystack4)
haystackSearch(haystack5)
haystackSearch(haystack6)
--wait for user to press a key to exit
any_key()
