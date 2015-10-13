#!/bin/sh
rot13() {
   tr a-zA-Z n-za-mN-ZA-M
}

cat "$@" | rot13
