parse version x 1 whatLang level mm mon yyyy .
if level<4 then do
                say
                say 'version' level "is too old!"
                say x       /*this displays everything.*/
                exit        /*or maybe:   EXIT 13      */
                end
