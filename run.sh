# Compile assembly for linux x64
yasm -f elf64 -g dwarf2 -o m.o msweep.asm

# Link and compile assembly and C
gcc -no-pie -g -o m m.o msweep.c

# Run
./m

# Delete execution files
rm m.o && rm m
