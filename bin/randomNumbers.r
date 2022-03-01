#!/usr/bin/env R
numbers <- rep(-100, 15)
numbers
for (i in 1:15) { #0; i<numbers.length; i++) {
    r = floor(runif(1, 1, 500))
    if(length(numbers[abs(numbers - r)>20])){
        numbers[i] = r
    }
}
numbers