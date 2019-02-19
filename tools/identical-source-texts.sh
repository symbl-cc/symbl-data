# List which English source strings are identical, omitting Ideograph.

rm -f tmp
for path in `find ../loc/en/symbols -type f -name '*.txt'`;do
    #TODO Should work with [A-F0-9]{4,5} but it didn't.
    sed -e 's/^[A-F0-9][A-F0-9][A-F0-9][A-F0-9]:$//' $path | sed -e 's/^[A-F0-9][A-F0-9][A-F0-9][A-F0-9]: //' | sed -e 's/^[A-F0-9][A-F0-9][A-F0-9][A-F0-9][A-F0-9]:$//' | sed -e 's/^[A-F0-9][A-F0-9][A-F0-9][A-F0-9][A-F0-9]: //' | sed -e '/^\s*$/d' >> tmp
done
echo "Counted following identical English source strings:"
sort tmp|uniq -c|grep -v Ideograph|sort -nr|grep -v "^      1"
echo "Omitting identical source strings related to Ideograph"
rm -f tmp
