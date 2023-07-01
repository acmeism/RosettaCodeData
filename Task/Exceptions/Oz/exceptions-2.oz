try
   raise someError(debug:unit) end
catch someError(debug:d(stack:ST ...)...) then
   {Inspect ST}
end
