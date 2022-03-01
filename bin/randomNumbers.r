#!/usr/bin/env Rscript
numbers <- rep(-100, 15)
numbers

for (i in 1:15) { 
    r = floor(runif(1, 1, 500)) # one random number chozen from 1 to 500 
    while(length(numbers[abs(numbers - r)>20]) != 15){
        r = floor(runif(1, 1, 500))
    } 
    numbers[i] = r
}
numbers