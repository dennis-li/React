#!/bin/sh


matchHeadFiles()
{
	lines=`grep -c -E '<React/*' $1`
	if [ $lines != "0" ]; then
		files=`sed -n '/<React/p' ./RCTBridge.h`
		for ((i=1; i<=$lines; i=i+1));
			do
				replaceHeadFiles $i $1
			done
	fi

}

replaceHeadFiles()
{
	fileName=`grep -E '<React/*' $2 |  cut -d "/" -f2 | cut -d "." -f1 | head -$1 | tail -1` 
	line=`grep -n -E '<React/*' $2 | cut -d ":" -f1 | head -$1 | tail -1`
	sed -i ' ' "${line}s/.*/#import \"${fileName}.h\"/" $2
}

for file in ./*.h
	       do
	       		matchHeadFiles $file
	       done

