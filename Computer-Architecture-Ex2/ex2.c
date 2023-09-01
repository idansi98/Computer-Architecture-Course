// 206821258 Idan Simai

#include "ex2.h"
#define MASK1 0x80000000
#define MASK2 0x7FFFFFFF
#define SHIFTER 31

//This function is to convert from Magnitude Representation to int Representation.
magnitude converter(int a) {
    int sign = a >> SHIFTER;
    return (((a & MASK1) - a) & sign) | (~sign & a);
}

//This function deals with addition of two magnitudes.
magnitude add(magnitude a, magnitude b) {
    //If addition of two positives is negative, we return - the answer.
    if(converter(a) > 0 && converter(b) > 0) {
        if((converter(converter(a) + converter(b))) < 0)
            return - (converter(converter(a) + converter(b)));
    }
    //If addition of two negatives is positive, we return - the answer.
    if(converter(a) < 0 && converter(b) < 0) {
        if((converter(converter(a) + converter(b))) > 0)
            return - (converter(converter(a) + converter(b)));
    } else
    return converter((converter(a) + converter(b)));
}

//This function deals with subtraction of two magnitudes.
magnitude sub(magnitude a, magnitude b) {
    //If Subtraction of negative from positive is negative, we return - the answer.
    if(converter(a) > 0 && - converter(b) > 0) {
        if((converter(converter(a) - converter(b))) < 0)
            return - (converter(converter(a) - converter(b)));
    }
    //If Subtraction of positive from negative is positive, we return - the answer.
    if (converter(a) < 0 && - converter(b) < 0) {
        if((converter(converter(a) - converter(b))) > 0)
            return - (converter(converter(a) - converter(b)));
    }
    return converter((converter(a) - converter(b)));
}

//This function deals with multiplication of two magnitudes.
magnitude multi(magnitude a, magnitude b) {
    //If Multiplication of two positives is negative, we return - the answer.
    if(converter(a) > 0 && converter(b) > 0) {
        if((converter(converter(a) * converter(b))) < 0)
            return - (converter(converter(a) * converter(b)));
    }
    //If Multiplication of two negatives is positive, we return - the answer.
    if(converter(a) < 0 && converter(b) < 0) {
        if((converter(converter(a) * converter(b))) < 0)
            return - (converter(converter(a) * converter(b)));
    }
    //If Multiplication of positive and negative is positive, we return - the answer.
    if(converter(a) > 0 && - converter(b) > 0) {
        if((converter(converter(a) * converter(b))) > 0)
            return - (converter(converter(a) * converter(b)));
    }
    //If Multiplication of negative and positive is positive, we return - the answer.
    if( - converter(a) > 0 && converter(b) > 0) {
        if((converter(converter(a) * converter(b))) > 0)
            return - (converter(converter(a) * converter(b)));
    }
    return converter((converter(a) * converter(b)));
    }

//This function checks whether two magnitudes are equal or not.
int equal(magnitude a, magnitude b) {
    //Here we deal with the situation of -0 and 0.
    if(((a & MASK2) == 0) && ((b & MASK2) == 0)) {
            return 1;
    }
    if(((a & MASK2) == (b & MASK2)) && ((a & MASK1) == (b & MASK1))) {
            return 1;
        }
    return 0;
}

//This function checks whether one magnitude is greater than the other one.
int greater(magnitude a, magnitude b) {
    //Here we deal with the situation of -0 and 0.
    if(((a & MASK2) == 0) && ((b & MASK2) == 0)) {
        return 0;
    }
    //If both of them are positive.
    if (!(a & MASK1) && !(b & MASK1)) {
        if(a > b) {
            return 1;
        }
        return 0;
    }
    //If both of them are negative.
    if((a & MASK1) && (b & MASK1)) {
        if ((a & MASK2) < (b & MASK2)) {
            return 1;
        }
        return 0;
    }
    //If the first one is positive and the second one is negative.
    if(!(a & MASK1) && (b & MASK1)) {
        return 1;
    }
    return 0;
}