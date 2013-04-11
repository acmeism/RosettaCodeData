/*REXX program to show interactive programming by using a function [F]. */
say '══════════════════ enter the function  F  with three arguments:'
parse pull funky
interpret 'SAY' funky
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────F subroutine────────────────────────*/
f:  return arg(1) || copies(arg(3),2) || arg(2)   /*return required str.*/
