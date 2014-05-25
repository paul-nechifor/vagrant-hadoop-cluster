package net.nechifor.autosuggest;

import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapred.*;

import java.io.IOException;
import java.util.*;

public class App {
    public static class Map extends MapReduceBase implements
            Mapper<LongWritable, Text, Text, IntWritable> {

        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();
        private int n = -1;

        @Override
        public void configure(JobConf job) {
            super.configure(job);
            n = job.getInt("n", 3);
        }

        @Override
        public void map(LongWritable key, Text value, OutputCollector<Text,
                IntWritable> output, Reporter reporter) throws IOException {

            String line = value.toString();
            Scanner scanner = new Scanner(line);
            LinkedList<String> l = new LinkedList<String>();

            if (!extract(l, scanner, n - 1)) {
                return;
            }

            while (scanner.hasNext()) {
                l.add(scanner.next().toLowerCase());
                word.set(join(l, " "));
                output.collect(word, one);
                l.removeFirst();
            }
        }

        private boolean extract(List<String> l, Scanner scanner, int n) {
            for (int i = 0; i < n; i++) {
                if (scanner.hasNext()) {
                    l.add(scanner.next().toLowerCase());
                } else {
                    return false;
                }
            }
            return true;
        }

        private String join(List<String> l, String sep) {
            StringBuilder sb = new StringBuilder();
            boolean first = true;
            for (String e : l) {
                sb.append(e);
                if (first) {
                    first = false;
                } else {
                    sb.append(sep);
                }
            }
            return sb.toString();
        }
    }

    public static class Reduce extends MapReduceBase implements Reducer<Text,
            IntWritable, Text, IntWritable> {

        @Override
        public void reduce(Text key, Iterator<IntWritable> values,
                OutputCollector<Text, IntWritable> output, Reporter reporter)
                throws IOException {
            int sum = 0;
            while (values.hasNext()) {
                sum += values.next().get();
            }
            output.collect(key, new IntWritable(sum));
        }
    }

    public static void main(String[] args) throws Exception {
        JobConf conf = new JobConf(App.class);
        conf.setInt("n", 4);
        conf.setJobName("ngrams");

        conf.setOutputKeyClass(Text.class);
        conf.setOutputValueClass(IntWritable.class);

        conf.setMapperClass(Map.class);
        conf.setCombinerClass(Reduce.class);
        conf.setReducerClass(Reduce.class);

        conf.setInputFormat(TextInputFormat.class);
        conf.setOutputFormat(TextOutputFormat.class);

        configureIo(args[0], args[1], conf);

        JobClient.runJob(conf);
    }

    private static void configureIo(String in, String out, JobConf conf)
            throws IOException {
        FileSystem fs = FileSystem.get(conf);
        FileStatus[] statusList = fs.listStatus(new Path(in));

        if (statusList == null) {
            throw new IOException();
        }

        for (FileStatus status : statusList) {
            FileInputFormat.addInputPath(conf, status.getPath());
        }


        FileOutputFormat.setOutputPath(conf, new Path(out));
    }
}