#!/usr/local/bin/apl --script --

⍝⍝ GNU APL script
⍝⍝ Usage: errout.apl <code>
⍝⍝
⍝⍝ $ echo $?   ## to see exit code
⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝⍝
args ← 2↓⎕ARG~'--script' '--'  ⍝⍝ strip off script args we don't need

err ← ⍎⊃args[1]

∇main
  →(0=err)/ok
error:
  'Error! exiting.'
  ⍎')off 1'         ⍝⍝ NOTE: exit code arg was added to )OFF in SVN r1499 Nov 2021
ok:
  'No error, continuing...'
  ⍎')off'
∇

main
