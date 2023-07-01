# syntax: GAWK -f SUBLEQ.AWK SUBLEQ.TXT
# converted from Java
BEGIN {
    instruction_pointer = 0
}
{   printf("%s\n",$0)
    for (i=1; i<=NF; i++) {
      if ($i == "*") {
        ncomments++
        break
      }
      mem[instruction_pointer++] = $i
    }
}
END {
    if (instruction_pointer == 0) {
      print("error: nothing to run")
      exit(1)
    }
    printf("input: %d records, %d instructions, %d comments\n\n",NR,instruction_pointer,ncomments)
    instruction_pointer = 0
    do {
      a = mem[instruction_pointer]
      b = mem[instruction_pointer+1]
      if (a == -1) {
        getline <"con"
        mem[b] = $1
      }
      else if (b == -1) {
        printf("%c",mem[a])
      }
      else {
        mem[b] -= mem[a]
        if (mem[b] < 1) {
          instruction_pointer = mem[instruction_pointer+2]
          continue
        }
      }
      instruction_pointer += 3
    } while (instruction_pointer >= 0)
    exit(0)
}
