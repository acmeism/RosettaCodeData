def choice:
  def read(prompt; max):
    def __read__:
      prompt,
      ( input as $input
        | if ($input|type) == "number" and 0 < $input and $input <= max then $input
          else __read__
          end);
    __read__;

  if length == 0 then ""
  else
  . as $in
  | ("Enter your choice:\n" +
     (reduce range(0; length) as $i (""; . + "\($i + 1): \($in[$i])\n")) ) as $prompt
  | read($prompt; length) as $read
  | if ($read|type) == "string" then $read
    else "Thank you for selecting \($in[$read-1])" end
  end ;
