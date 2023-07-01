   exec assemble 'LDA 3; ADD 4; STP; 2; 2'
4
   exec assemble 'LDA 12; ADD 10; STA 12; LDA 11; SUB 13; STA 11; BRZ 8; JMP; LDA 12; STP; 8; 7; 0; 1'
56
   exec assemble 'LDA 14; STA 15; ADD 13; STA 14; LDA 15; STA 13; LDA 16; SUB 17; BRZ 11; STA 16; JMP; LDA 14; STP; 1; 1; 0; 8; 1'
55
   exec assemble 'LDA 13; ADD 15; STA 5; ADD 16; STA 7; NOP; STA 14; NOP; BRZ 11; STA 15; JMP; LDA 14; STP; LDA; 0; 28; 1; 0; 0; 0; 6; 0; 2; 26; 5; 20; 3; 30; 1; 22; 4; 24'
6
   exec assemble 'NOP; NOP; STP; NOP; LDA 3; SUB 29; BRZ 18; LDA 3; STA 29; BRZ 14; LDA 1; ADD 31; STA 1; JMP 2; LDA; ADD 31; STA; JMP 2; LDA 3; STA 29; LDA 1; ADD 30; ADD 3; STA 1; LDA; ADD 30; ADD 3; STA; JMP 2; 0; 1; 3'
0
