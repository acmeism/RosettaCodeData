main: { "ha" 5 print_repeat }

print_repeat!: { <- { dup << } -> times }
