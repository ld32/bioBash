#!/bin/sh

# features:
# insert a piece of sequenc to chromesomes to 1 based location
#
# todo:
# 

set -vx 
#set -e 

echoerr() { echo -e "$@" 1>&2; exit 1; }

usage() { echo -e "Usage: \modifyGTF.sh <nomal.gtf, required> <insert.fa required>\n";
    cat << 'EOF'
For example: 
    $ cat data/sample.gtf
    chr1	unknown	exon	3214482	3216968	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	stop_codon	3216022	3216024	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	CDS	3216025	3216968	.	-	2	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	CDS	3	9	.	-	1	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	exon	1	4	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	CDS	7	10	.	-	0	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr3	unknown	exon	7	9	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr3	unknown	start_codon	5	13	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	exon	4290846	4293012	.	-	.	gene_id "Rp1"; gene_name "Rp1"; p_id "P17361"; transcript_id "NM_001195662"; tss_id "TSS6138";
    chr1	unknown	stop_codon	4292981	4292983	.	-	.	gene_id "Rp1"; gene_name "Rp1"; p_id "P17361"; transcript_id "NM_001195662"; tss_id "TSS6138";
        
    $ cat data/insert.fa
    >chr2 4
    abc
    >chr3  5
    ddd
    
    $ bin/instertGenome.sh data/sample.gtf data/insert.fa
    $ cat gtfWithInsert.gtf
    chr1	unknown	exon	3214482	3216968	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	stop_codon	3216022	3216024	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	CDS	3216025	3216968	.	-	2	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	CDS	3	12	.	-	1	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	exon	1	7	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr2	unknown	CDS	10	13	.	-	0	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr3	unknown	exon	10	12	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr3	unknown	start_codon	8	16	.	-	.	gene_id "Xkr4"; gene_name "Xkr4"; p_id "P15391"; transcript_id "NM_001011874"; tss_id "TSS27105";
    chr1	unknown	exon	4290846	4293012	.	-	.	gene_id "Rp1"; gene_name "Rp1"; p_id "P17361"; transcript_id "NM_001195662"; tss_id "TSS6138";
    chr1	unknown	stop_codon	4292981	4292983	.	-	.	gene_id "Rp1"; gene_name "Rp1"; p_id "P17361"; transcript_id "NM_001195662"; tss_id "TSS6138";
EOF
exit 1
}

[ -f "$1" ] && [ -f "$2" ] || usage

echo Running $0 "$@" 1>&2 

declare -A loc
declare -A length

while read -r line || [ -n "$line" ]; do
    if [[ ">" == "${line:0:1}" ]]; then 
        id=${line%% *}
        loc[$id]=${line##* }
    else 
        line=${line// /}
        length[$id]=$((${length[$id]} + ${#line}))
    fi 
done <$2

rm gtfWithInsert.gtf 2>/dev/null

while read -r line || [ -n "$line" ]; do
    IFS=$'\t'; arr=($line)
    chr=">${arr[0]}"
    if [ ! -z "${loc[$chr]}" ]; then
        if [ "${arr[3]}" -ge "${loc[$chr]}" ]; then
            arr[3]=$((${arr[3]} + ${length[$chr]}))
            arr[4]=$((${arr[4]} + ${length[$chr]}))
        elif [ "${arr[4]}" -ge "${loc[$chr]}" ]; then
            arr[4]=$((${arr[4]} + ${length[$chr]}))
        fi
    fi    
    IFS=$'\t'; echo "${arr[*]}" >> gtfWithInsert.gtf 
done <$1

echo done
