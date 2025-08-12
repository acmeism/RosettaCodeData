def pancake(n)
  init = (1..n).to_a
  stack_flips = { init => 0 }
  queue = [init]

  until queue.empty?
    # NOTE: Ruby does not reallocate the entire array for every call to `shift`.
    stack = queue.shift
    flips = stack_flips[stack] + 1

    (2..n).each do |i|
      flipped = [*stack[...i].reverse, *stack[i..]]
      unless stack_flips.key?(flipped)
        stack_flips[flipped] = flips
        queue.push(flipped)
      end
    end
  end

  stack_flips.max_by { |_, v| v }
end

(1...10).each do |n|
  pancakes, p = pancake(n)
  printf("pancake(%d) = %2d. Example %s\n", n, p, pancakes)
end
