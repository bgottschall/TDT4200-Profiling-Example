#include <iostream>
#include <vector>
#include <stdlib.h>
#include <time.h>


#define DEFAULT_DIM 10000
static long dim = DEFAULT_DIM;

long int lrand()
{
    if (sizeof(unsigned int) < sizeof(unsigned long int))
        return ( (unsigned long int) (rand()) << (sizeof(unsigned int) * 8)) |
               rand();

    return rand();
}

void initializeVector(std::vector<unsigned long int> &vec)
{
    for (unsigned long int &x : vec) {
        x = lrand();
    }
}

unsigned long int gcd(unsigned long int a, unsigned long int b){
    if(b == 0)
        return a;
    else return gcd(b, a % b);
}


unsigned long int lcm(unsigned long int a, unsigned long int b)
{
    unsigned long int t = gcd(a,b);
    return (t == 0) ? 0 : (a * b) / t;
}


unsigned long int vecGcd(std::vector<unsigned long int> &vec) {
    if (vec.size() == 0)
        return 0;
    unsigned long int res = vec[0];
    for (unsigned int i = 0; i < dim; i++) {
        for (unsigned int j = 0; j < dim; j++) {
            res = gcd(res, vec[j * dim + i]);
        }
    }
    return res;
}

unsigned long int vecLcm(std::vector<unsigned long int> &vec) {
    if (vec.size() == 0)
        return 0;
    unsigned long int res = vec[0];
    for (unsigned int i = 0; i < dim; i++) {
        for (unsigned int j = 0; j < dim; j++) {
            res = lcm(res, vec[j * dim + i]);
        }
    }
    return res;
}


int main(int argc, char **argv) {
    if (argc > 1) {
        dim = strtol(argv[1], NULL, 10);
    }

    // Initialize random number generator:
    srand(time(NULL));

    // Create a vector with dim x dim elements
    std::vector<unsigned long int> a;
    a.resize(dim * dim);

    // Initialize the vector with random numbers:
    initializeVector(a);

    std::cout << "Greatest common divider: " << vecGcd(a) << std::endl;
    std::cout << "Least common multiple: " << vecLcm(a) << std::endl;

    return 0;
}