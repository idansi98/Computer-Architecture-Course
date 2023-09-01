#include <stdio.h>

///this is code in c, your code needs to be in assembly
/// good luck!
int even (int num, int i){
    return num << i;
}


int go (int A[13]) {
    int sum = 0;
    int i = 0;
    while (i < 13) {
        if (A[i] % 2 == 0) {
            int num = even (A[i], i);
            sum += num;
        } else {
            sum += A[i];
        }
        i++;
    }
    return sum;
}


int main()
{
    int array[13] = {-4,1,3,0,5,2,1,1,1,1,1,1,1};
    int answer = go(array);
    printf("this is you answer: %d", answer);

    return 0;
}