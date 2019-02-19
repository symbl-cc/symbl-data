# Count translations files and lines and write voerview in TSV file.

function count {
	echo 'INFO: Counting directories, files and lines for language "'$lang'"...'
	for path in `find ../loc/$lang -type d`; do
		dirs=$((++dirs))
	done
	for path in `find ../loc/$lang -type f -name '*.txt'`; do
		files=$((++files))
		lines=$((lines+`wc -l $path|awk '{print $1}'`))
	done
	echo '`'$lang'` | `'$dirs'` | `'$files'` | `'$lines'`' >> overview.md
}

# Header
echo 'language | directories | files | lines' > overview.md
echo '---------|------------:|------:|-----:' >> overview.md

# First English
lang=en
dirs=0
files=0
lines=0
count

# All other languages
for lang in `ls ../loc/|sort`; do
	if [ $lang == 'en' ]; then
		continue
	fi
	dirs=0
	files=0
	lines=0
	count
done
