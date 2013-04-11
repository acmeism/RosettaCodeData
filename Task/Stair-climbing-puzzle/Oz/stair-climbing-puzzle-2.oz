proc {StepUp}
   Level = {NewCell 0}
in
   for until:@Level == 1 do
      if {Step} then Level := @Level + 1
      else Level := @Level - 1
      end
   end
end
