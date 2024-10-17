name: myapp
version: "1.0"
author: A Rust Developer <rustme@home.com>
about: Does awesome things
args:
  - STRING1:
      about: First string to use
      required: true
      index: 1
  - STRING2:
      about: Second string to use
      required: true
      index: 2
  - SEPARATOR:
      about: Separtor to use
      required: true
      index: 3
