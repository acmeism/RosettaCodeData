HAI 1.3

I HAS A STATE ITZ "READY"
I HAS A INPUT
IM IN YR FSM UPPIN YR DUMMY TIL BOTH SAEM STATE AN "EXIT"
    VISIBLE "MASHEEN IZ :{STATE}. "!
    STATE, WTF?
        OMG "READY"
            VISIBLE "(D)EPOSIT OR (Q)UIT?"
            GIMMEH INPUT
            BOTH SAEM INPUT AN "D", O RLY?
                YA RLY, STATE R "WAITING"
                MEBBE BOTH SAEM INPUT AN "Q", STATE R "EXIT"
            OIC
            GTFO
        OMG "WAITING"
            VISIBLE "(S)ELECT OR (R)EFUND?"
            GIMMEH INPUT
            BOTH SAEM INPUT AN "S", O RLY?
                YA RLY, STATE R "DISPENSING"
                MEBBE BOTH SAEM INPUT AN "R", STATE R "REFUNDING"
            OIC
            GTFO
        OMG "DISPENSING"
            VISIBLE "PLZ (R)EMOVE PRODUKT."
            GIMMEH INPUT
            BOTH SAEM INPUT AN "R", O RLY?
                YA RLY, STATE R "READY"
            OIC
            GTFO
        OMG "REFUNDING"
            VISIBLE ""
            STATE R "READY"
            GTFO
    OIC
IM OUTTA YR FSM

KTHXBYE
