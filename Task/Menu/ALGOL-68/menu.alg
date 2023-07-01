PROC menu select := (FLEX[]STRING items, UNION(STRING, VOID) prompt)STRING:
(
        INT choice;

        IF LWB items <= UPB items THEN
                WHILE
                        FOR i FROM LWB items TO UPB items DO
                                printf(($g(0)") "gl$, i, items[i]))
                        OD;
                        CASE prompt IN
                                (STRING prompt):printf(($g" "$, prompt)),
                                (VOID):printf($"Choice ? "$)
                        ESAC;
                        read((choice, new line));
                # WHILE # 1 > choice OR choice > UPB items
                DO SKIP OD;
                items[choice]
        ELSE
                ""
        FI
);

test:(
        FLEX[0]STRING items := ("fee fie", "huff and puff", "mirror mirror", "tick tock");
        STRING prompt := "Which is from the three pigs : ";

        printf(($"You chose "g"."l$, menu select(items, prompt)))
)
