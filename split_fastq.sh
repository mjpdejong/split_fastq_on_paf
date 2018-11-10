reads=test.fastq
outputfolder=$PWD
round=1

#max number length
mnl=9

cat -n $reads | sed -n 1~4p | awk '{ printf("%s %0"'"$mnl"'"d %0"'"$mnl"'"d %0"'"$mnl"'"d %0"'"$mnl"'"d \n" ,$2, $1, $1+1, $1+2, $1+3) }' | tr -d '@' | sort > $outputfolder/fastqindex.txt

nl -n rz -w $mnl $reads > $outputfolder/fastq.sorted

for paf in $outputfolder/round-$round/*.paf ; do

    bin=$(basename $paf | cut -d . -f 1)

    join $outputfolder/fastq.sorted <( \

		join <( cat $outputfolder/fastqindex.txt ) <( awk '{print $1}' $paf | sort -u ) | \

		awk '{print $2 "\n" $3 "\n" $4 "\n" $5}' | sort ) | \

	sort | cut -d ' ' -f 2- > $outputfolder/round-$round/$bin.fastq

done

