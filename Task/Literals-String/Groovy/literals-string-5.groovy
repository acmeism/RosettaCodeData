def regexString = /(\[[Tt]itle\]|\[[Ss]ubject\])${10 * 5}/

assert regexString == '(\\[[Tt]itle\\]|\\[[Ss]ubject\\])50'
