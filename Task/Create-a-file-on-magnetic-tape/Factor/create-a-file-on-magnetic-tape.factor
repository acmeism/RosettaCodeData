USING: io.encodings.ascii io.files kernel system ;

"Hello from Rosetta Code!"
os windows? "tape.file" "/dev/tape" ?
ascii set-file-contents
