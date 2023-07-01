evaluate identifier-1
when 'good'
    good-imperative-statement
when 'bad'
    bad-imperative-statement
when 'ugly'
when 'awful'
    ugly-or-awful-imperative-statement
when other
    default-imperative-statement
end-evaluate

evaluate true
when condition-1
    condition-1-imperative-statement
when condition-2
    condition-2-imperative-statement
when condition-3
    condition-3-imperative-statement
when other
    default-condition-imperative-statement
end-evaluate

evaluate identifier-1 also identifier-2
when 10 also 20
   one-is-10-and-two-is-20-imperative-statement
when 11 also 30
   one-is-11-and-two-is-30-imperative-statement
when 20 also any
   one-is-20-and-two-is-anything-imperative-statement
when other
   default-imperative-statement
end-evaluate
