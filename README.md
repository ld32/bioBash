# bioBash

## insertGenome.sh

Usage: instertGenome.sh <nomalGenome.fa, required> <insert.fa required>

For example: 

    $ cat genome.fa
    >chr1
    1234567891
    >chr2
    1234567892
    >chr3
    1234567893
    >chr4
    123
    
    $ cat insert.fa
    >chr2 4
    abc
    >chr3  5
    ddd

    $ cat genomeWithInsert.fa
    >chr1
    1234567891
    >chr2
    123
    abc
    4567892
    >chr3
    1234
    ddd
    567893
    >chr4
    123

