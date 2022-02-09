#!/bin/sh

# features:
# insert a piece of sequenc to chromesomes to 1 based location
#
# todo:
# 

#set -vx 
#set -e 

echoerr() { echo -e "$@" 1>&2; exit 1; }

usage() { echo -e "Usage: \ninstertGenome.sh <nomalGenome.fa, required> <insert.fa required>\n";
    cat << 'EOF'
For example: 
    $ cat data/genome.fa
    >chr1
    1234567891
    >chr2
    1234567892
    >chr3
    1234567893
    >chr4
    123
    
    $ cat data/insert.fa # - means the insert is reversed completment sequence
    >chr2 - 4
    cat
    >chr3 5
    ddd

    $ bin/instertGenome.sh data/genome.fa insert.fa
    $ cat withInsert.genome.fa
    >chr1
    1234567891
    >chr2
    123
    atg
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

strand=""
while read -r line || [ -n "$line" ]; do
    if [[ ">" == "${line:0:1}" ]]; then
        [[ "$strand" == *-* ]] && seq[$id]=`echo ${seq[$id]} | tr ACGTacgt TGCAtgca | rev`        
        id=${line%% *}
        strand=${line% *}; strand=${strand#* }
        loc[$id]=${line##* }
    else 
        line=${line// /}
        seq[$id]="${seq[$id]}$line"
    fi 
done <$2
[[ "$strand" == *-* ]] && seq[$id]=`echo ${seq[$id]} | tr ACGTacgt TGCAtgca | rev`

find=""
rm genomeWithInsert.fa 2>/dev/null
while read -r line || [ -n "$line" ]; do
    if [[ ">" == "${line:0:1}" ]]; then 
        id=${line%% *} 
        echo $line >> genomeWithInsert.fa
        [ ! -z "${loc[$id]}" ] && find=$id && len=0 && location="${loc[$id]}" && doneIt="n" || find=""
    else 
        if [ -z "$find" ]; then 
            echo $line >> genomeWithInsert.fa
        elif [ -z "$doneIt" ]; then 
            echo $line >> genomeWithInsert.fa    
        else 
            line=${line// /}
            len1=$((len + ${#line}))
            if [ $len1 -gt $location ]; then
                breakpoint=$(($location - $len - 1))
                echo ${line:0:$breakpoint} >> genomeWithInsert.fa
                echo ${seq[$find]} >> genomeWithInsert.fa
                echo ${line:$breakpoint:${#line}} >> genomeWithInsert.fa
                doneIt=""
            else 
                echo $line >> genomeWithInsert.fa
            fi
            len=$len1
        fi
    fi
done <$1
echo done
