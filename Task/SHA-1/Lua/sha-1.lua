#!/usr/bin/lua

local sha1 = require "sha1"

for i, str in ipairs{"Rosetta code", "Rosetta Code"} do
  print(string.format("SHA-1(%q) = %s", str, sha1(str)))
end
