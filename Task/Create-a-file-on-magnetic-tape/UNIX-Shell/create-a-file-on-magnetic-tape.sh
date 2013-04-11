#!/bin/sh
cd    # Make our home directory current
echo "Hello World!" > hello.jnk  # Create a junk file
# tape rewind                    # Uncomment this to rewind the tape
tar c hello.jnk                  # Traditonal archivers use magnetic tape by default
# tar c hello.jnk > /dev/tape    # With newer archivers redirection is needed
