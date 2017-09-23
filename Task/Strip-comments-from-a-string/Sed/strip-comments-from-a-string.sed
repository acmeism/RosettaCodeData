#!/bin/sh
# Strip comments
echo "$1" | sed 's/ *[#;].*$//g' | sed 's/^ *//'
