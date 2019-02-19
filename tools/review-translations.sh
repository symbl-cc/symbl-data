# Reports translations, i.e. the differences, in side-by-side colored HTML for review purposes.

function report_differences {
	echo 'INFO: Reporting the translation (difference) between languages "en" and "'$lang'"...'
	if [ -e reviews/$lang ]; then
		rm -rf reviews/$lang
	fi
	mkdir -p reviews/$lang
	for source_path in `find ../loc/en -type f -name '*.txt'|sort`; do
		source=`basename $source_path`
		output_directory=reviews/$lang`echo $source_path|sed -e 's/^\.\.\/loc\/en//'|sed -e 's/\/[^\/]*$//'`
		destination_path=`echo $source_path|sed -e 's/\.\.\/loc\/en\//\.\.\/loc\/'$lang'\//'`
		if [ -s $source_path ]; then
    			if [ -s $destination_path ]; then
			        if [ `diff -u $source_path $destination_path|wc -l` -ne 0 ]; then
					if [ ! -e $output_directory ]; then
						mkdir -p $output_directory
					fi
					echo 'INFO: Comparing '$destination_path'...'
					diff -u $source_path $destination_path | diff2html -s side --sc enabled -i stdin -F $output_directory/$source.html
				else
					echo 'WARNING: Identical untranslated file '$destination_path
				fi
			else
				if [ -e $destination_path ]; then
					echo 'WARNING: Empty translation file '$destination_path
#				else
#					echo 'WARNING: Missing translation file '$destination_path
				fi
			fi
		else
			if [ -e $source_path ]; then
				echo 'WARNING: Empty source file '$source_path
			fi
		fi
	done
}

if [ -z `which diff2html` ]; then
	echo 'ERROR: Missing diff2html, see README.md on how to install'
	exit 1
fi 

if [ $# -eq 1 ]; then
	# only one specific language
	lang=$1
	if [ $1 != 'en' -a -e ../loc/$1 ]; then
		report_differences
	else
		echo 'ERROR: Not possible to compare language '$lang' with English source language'
	fi
else
	# all langauges, this takes a long time!
	for lang in `ls ../loc/|sort`; do
		if [ $lang == 'en' ]; then
    			continue
		fi
		report_differences
	done
fi

