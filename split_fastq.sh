reads=test.fastq
outputfolder=$PWD
round=1


cat -n $reads | sed -n 1~4p | awk '{print $2 " " $1 " " $1+1 " " $1+2 " " $1+3}' | tr -d '@' | sort > $outputfolder/fastqindex.txt

cat -n $reads | sort -k 1b,1 > $outputfolder/fastq.sorted

for paf in $outputfolder/round-$round/*.paf ; do

    bin=$(basename $paf | cut -d . -f 1)

    join $outputfolder/fastq.sorted <( \

		join <( cat $outputfolder/fastqindex.txt ) <( awk '{print $1}' $paf | sort -u ) | \

		awk '{print $2 "\n" $3 "\n" $4 "\n" $5}' | sort ) | \

	sort -n | cut -d ' ' -f 2- > $outputfolder/round-$round/$bin.fastq

done

