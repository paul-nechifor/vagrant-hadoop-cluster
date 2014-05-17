# Compile the Java example to a JAR.
mkdir classes
javac -classpath /opt/hadoop/hadoop-core-1.2.1.jar -d classes WordCount.java
jar -cf wordcount.jar -C classes .
rm -fr classes

# Some cleanup.
hadoop fs -rm /input-file
hadoop fs -rmr /output

# Copy the input-file.
hadoop fs -copyFromLocal input-file /

# Run the job.
hadoop jar wordcount.jar org.myorg.WordCount /input-file /output

# List the results.
hadoop fs -cat /output/part-00000
