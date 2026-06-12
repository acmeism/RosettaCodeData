#!/usr/bin/env coffee

meaningOfLife = () -> 42

exports.meaningOfLife = meaningOfLife

main = () ->
  console.log "Main: The meaning of life is " + meaningOfLife()

if not module.parent then main()
