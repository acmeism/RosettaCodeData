/*REXX program demonstrates  interactive programming  by using a  function [F].         */
say '══════════════════ enter the function  F  with three comma-separated arguments:'
parse pull funky
interpret  'SAY'  funky
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
f:  return arg(1) || copies(arg(3),2) || arg(2)  /*return the required string to invoker*/
