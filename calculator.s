# A terminal calculator
#
# Reads a line of input, interprets it as a simple arithmetic expression,
# and prints the result. The input format is
# <long_integer> <operation> <long_integer>

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

main:
  # Function prologue
  enter $0, $0

  # Use scanf to retrieve and process a line of input
  # This block implements the following line of C code: 
  #   scanf("%ld %c %ld", &a, &op, &b);
  # Take a look at the man page for scanf and ask questions. You can also look 
  # at scanf_example.c
  
  movq $scanf_fmt, %rdi
  movq $a, %rsi
  movq $op, %rdx
  movq $b, %rcx
  xorb %al, %al
  call scanf

  movb op(%rip), %al
  movq a(%rip), %r8
  movq b(%rip), %r9

  cmpb $'+', %al
  je .Ladd
  cmpb $'-', %al
  je .Lsub
  cmpb $'*', %al
  je .Lmultiply
  cmpb $'/', %al
  je .Ldivide
  jmp .Lna

.Ladd:
  movq %r8, %rax
  addq %r9, %rax
  jmp .Lprint
.Lsub:
  movq %r8, %rax
  subq %r9, %rax
  jmp .Lprint
.Lmultiply:
  movq %r8, %rax
  imulq %r9, %rax
  jmp .Lprint
.Ldivide:
  testq %r9, %r9
  je .Ldivzero
  movq %r8, %rax
  cqto
  idivq %r9
  jmp .Lprint
.Ldivzero:
  leaq err_div0(%rip), %rdi
  xorl  %eax, %eax
  call  puts
  movl  $1, %eax             
  jmp done

.Lna:
  leaq  err_unknown(%rip), %rdi
  xorl  %eax, %eax
  call  puts
  movl  $1, %eax             
  jmp done

.Lprint:
  leaq  output_fmt(%rip), %rdi
  movq  %rax, %rsi
  xorl  %eax, %eax
  call  printf
  xorl  %eax, %eax           
  jmp done
done:
  leave
  ret


# Start of the data section
.data

output_fmt: 
  .asciz "%ld\n"
scanf_fmt: 
  .asciz "%ld %c %ld"  # TODO: modify as needed
err_unknown:
  .asciz "Unknown operation."
err_div0:
  .asciz "Division by zero."

# "Slots" for scanf
a:  .quad 0
b:  .quad 0
op: .byte 0

