nim=: {{
  prompt tokens=: 12
}}

prompt=: {{
  echo 'tokens: ',":tokens
  if. 1>tokens do.
    echo 'game over'
  else.
    echo 'take 1, 2 or 3 tokens'
  end.
}}

take=: {{
  assert. y e.1 2 3
  assert. 0=#$y
  echo 'tokens: ',":tokens=:tokens-y
  echo 'I take ',(":t=. 4-y),' tokens'
  prompt tokens=:tokens-t
}}
