bioScripts
=============================

- [Insert reporter sequence to genome](#insertGenome.sh)

- [Modify .gtf file to match up the insersion](#modifyGTF.sh)

# insertGenome.sh
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
    
    >chr3 - 5  # '-' means the insert is reverse strand
    cat
    
    $ bin/instertGenome.sh data/genome.fa insert.fa
    $ cat genomeWithInsert.fa
    >chr1
    1234567891
    >chr2
    123
    abc
    4567892
    >chr3
    1234
    atg
    567893
    >chr4
    123

# modifyGTF.sh
Usage: modifyGTF.sh <nomal.gtf, required> <insert.fa required>

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
    >chr3 - 5
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

