ws := (File name: 'output.txt') writeStream.
ws close.
Directory create: 'docs'.

ws := (File name: '/output.txt') writeStream.
ws close.
Directory create: '/docs'.
