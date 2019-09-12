% Dracula is a vampire.
% Also, you become a vampire if someone who is a vampire bites you.
vampire(dracula).
vampire(You) :- bites(Someone, You), vampire(Someone).

% Oh no! Dracula just bit Bob...
bites(dracula, bob).
