sudo apt-get install -y unzip # If you don't have it.

mkdir txt
find . -name '*.zip' -size -500k -exec unzip {} -d txt \;

hadoop fs -rmr /txt
hadoop fs -rmr /ngrams
hadoop fs -copyFromLocal txt /txt
hadoop jar ../target/autosuggest*.jar net.nechifor.autosuggest.App /txt /ngrams
hadoop fs -tail /ngrams/part-00000

rm -fr txt