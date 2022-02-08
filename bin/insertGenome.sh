#!/bin/sh

# features:
# insert a piece of sequenc to chromesomes to 1 based location
#
# todo:
# 

#set -vx 
set -e 

echoerr() { echo -e "$@" 1>&2; exit 1; }

usage() { echo -e "Usage: \ninstertGenome.sh <nomalGenome.fa, required> <insert.fa required>\n";
    cat << 'EOF'
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

    $ cat withInsert.genome.fa
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
EOF
exit 1
}

[ -f "$1" ] && [ -f "$2" ] || usage

echo Running $0 "$@" 1>&2 

declare -A seq
declare -A loc

while read -r line || [ -n "$line" ]; do
    if [[ ">" == "${line:0:1}" ]]; then 
        id=${line%% *}
        loc[$id]=${line##* }
    else 
        line=${line// /}
        seq[$id]="${seq[$id]}$line"
    fi 
done <$2

rm genomeWithInsert.fa 2>/dev/null

while read -r line || [ -n "$line" ]; do
    if [[ ">" == "${line:0:1}" ]]; then 
        id=${line%% *} 
        echo $line >> genomeWithInsert.fa
        [ ! -z "${loc[$id]}" ] && find=$id && len=0 || find=""
    else 
        line=${line// /}
        if [ -z "$find" ]; then 
            echo $line >> genomeWithInsert.fa
        else 
            len1=$((len + ${#line}))
            if [[ "$len1" -gt "${loc[$find]}" && ! -z "${loc[$id]}" ]]; then
                breakpoint=$((${loc[$id]} - len - 1))
                echo ${line:0:$breakpoint} >> genomeWithInsert.fa
                echo ${seq[$find]} >> genomeWithInsert.fa
                echo ${line:$breakpoint:${#line}} >> genomeWithInsert.fa
                loc[$id]=""
            else 
                echo $line >> genomeWithInsert.fa
            fi
            len=$len1
        fi
    fi
done <$1
