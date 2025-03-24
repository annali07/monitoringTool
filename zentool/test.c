#include <stdint.h>
#include <stdio.h>

static inline uint64_t invoke_microcode_callback(uint64_t arg1)
{
    uint64_t result = 0;

    asm volatile ("fpatan" : "=a"(result) : "a"(arg1));

    return result;
}


int main(int argc, char **argv)
{
    printf("%#lx\n", invoke_microcode_callback(0));
}
