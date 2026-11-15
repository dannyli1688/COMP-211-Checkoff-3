#include <stddef.h>
#include <stdlib.h>
#include <stdio.h>
#define COUNT 4

unsigned next_unused(unsigned x)
{
    unsigned square = x * x;
    (void)square; // Explicitly discard the value.
    return x + 1u;
}

unsigned next_logged(unsigned x)
{
    unsigned square = x * x;
    printf("square = %u\n", square);
    return x + 1u;
}

unsigned sum(const unsigned *values, size_t count)
{
    unsigned total = 0;
    for (size_t i = 0; i < count; ++i)
    {
        total += values[i];
    }
    return total;
}