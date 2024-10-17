include get.e

function menu_select(sequence items, object prompt)
    if length(items) = 0 then
        return ""
    else
        for i = 1 to length(items) do
            printf(1,"%d) %s\n",{i,items[i]})
        end for

        if atom(prompt) then
            prompt = "Choice?"
        end if

        return items[prompt_number(prompt,{1,length(items)})]
    end if
end function

constant items = {"fee fie", "huff and puff", "mirror mirror", "tick tock"}
constant prompt = "Which is from the three pigs? "

printf(1,"You chose %s.\n",{menu_select(items,prompt)})
