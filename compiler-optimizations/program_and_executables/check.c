#include <assert.h>
#include <stddef.h>
#include <stdio.h>

unsigned next_unused(unsigned x);
unsigned next_logged(unsigned x);
unsigned sum(const unsigned *values, size_t count);

int main(void)
{
    const unsigned values[] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

    unsigned plain = next_unused(7u);
    unsigned logged = next_logged(7u);
    assert(plain == 8u && logged == 8u);

    for (size_t n = 0; n <= sizeof values / sizeof values[0]; ++n)
    {
        unsigned expected = (unsigned)(n * (n + 1) / 2);
        assert(sum(values, n) == expected);
    }

    puts("Checks passed.");
    return 0;
}