USE: io
IN: hello-vocab

hello   ! error; hello hasn't been defined yet
: hello ( -- ) "Hello, world!" print ;
hello   ! visible here
