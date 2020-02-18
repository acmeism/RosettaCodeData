(:
  Using the EXPath File Module, which is built into most XQuery processors
  by default and thus does not need to get imported. Some processors bind the
  namespace automatically, others require explicit declaration.
:)

xquery version "3.1";

declare namespace file = 'http://expath.org/ns/file';

let $in       := 'input.txt'
let $out      := 'output.txt'
let $numbers  := tokenize(file:read-text($in))
let $result   := xs:numeric($numbers[1]) + xs:numeric($numbers[2])
return file:write-text($out, xs:string($result))
