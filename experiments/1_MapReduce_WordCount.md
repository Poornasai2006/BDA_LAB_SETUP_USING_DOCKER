# 📊 Experiment 1: MapReduce Word Count

## 🛠️ **Tool: Hadoop MapReduce**

**What is MapReduce?**
- Distributed computing framework for processing large datasets
- **Use Case**: Count word occurrences in massive text files across a cluster
- **Key Concepts**: Map (parallel processing) → Shuffle (grouping) → Reduce (aggregation)

---

## 🎯 Objective
Write and execute a MapReduce program to count word occurrences in a text file.

---

## 📋 Steps

### Step 1: Access NameNode Terminal

```bash
docker exec -it namenode bash
```

### Step 2: Create Java Program

```bash
# Create wordcount.java
cat > /tmp/wordcount.java << 'EOF'
import java.io.IOException;
import java.util.StringTokenizer;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class wordcount {
    public static class myMapper extends Mapper<Object, Text, Text, IntWritable> {
        private final static IntWritable one = new IntWritable(1);
        private Text word = new Text();

        public void map(Object key, Text value, Context context) 
            throws IOException, InterruptedException {
            StringTokenizer itr = new StringTokenizer(value.toString());
            while (itr.hasMoreTokens()) {
                word.set(itr.nextToken());
                context.write(word, one);
            }
        }
    }

    public static class myReducer extends Reducer<Text, IntWritable, Text, IntWritable> {
        private IntWritable result = new IntWritable();

        public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
            int sum = 0;
            for (IntWritable val : values) {
                sum += val.get();
            }
            result.set(sum);
            context.write(key, result);
        }
    }

    public static void main(String[] args) throws Exception {
        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "word count");
        job.setJarByClass(wordcount.class);
        job.setMapperClass(myMapper.class);
        job.setCombinerClass(myReducer.class);
        job.setReducerClass(myReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(IntWritable.class);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
EOF
```

### Step 3: Compile Java Program

Inside the container (from Step 1):

```bash
cd /tmp
javac -d . wordcount.java
jar -cvf wordcount.jar *.class
```

### Step 4: Create Input File

```bash
# Create sample input file
cat > /tmp/input.txt << 'EOF'
hadoop is great
hadoop is powerful
big data hadoop
hadoop mapreduce
hadoop hadoop
EOF
```

### Step 5: Put File in HDFS

```bash
# Put input file in HDFS
hadoop fs -put /tmp/input.txt /input.txt

# Verify
hadoop fs -ls /
```

### Step 6: Run MapReduce Job

```bash
# Execute the word count job
hadoop jar /tmp/wordcount.jar wordcount /input.txt /output
```

### Step 7: View Results

```bash
# View the output
hadoop fs -cat /output/part-r-00000
```

**Exit container:**
```bash
exit
```

---

## ✅ Expected Output

```
big     1
data    1
great   1
hadoop  6
is      2
mapreduce   1
powerful    1
```

---

## 🔍 What's Happening?

1. **Mapper**: Splits each line into words, emits `(word, 1)` pairs
2. **Shuffle**: Groups all occurrences of the same word
3. **Reducer**: Sums up counts for each word
4. **Output**: Writes final word counts to `/output`

---

## 📊 Data Flow

```
Input: "hadoop is great"
       ↓
Map:   (hadoop, 1), (is, 1), (great, 1)
       ↓
Shuffle: Group by word
       ↓
Reduce: hadoop=[1,1,1,1,1,1] → (hadoop, 6)
        is=[1,1] → (is, 2)
       ↓
Output: hadoop  6
        is      2
        ...
```

---

## 💡 Learning Points

- ✅ How MapReduce processes data in parallel
- ✅ Mapper and Reducer functions
- ✅ Key-value pair transformations
- ✅ HDFS file operations
- ✅ Job execution and monitoring

---

## 🐛 Troubleshooting

**Compilation errors?**
```bash
# Check Java version
java -version
javac -version

# Make sure you're in /tmp
pwd
```

**Job fails?**
```bash
# Check input file
hadoop fs -cat /input.txt

# Check HDFS health
hadoop dfsadmin -report

# Check application logs
hadoop logs <application_id>
```

**Output not found?**
```bash
# List output directory
hadoop fs -ls /output

# Count output files
hadoop fs -ls -R /output
```

---

## 🎯 Next Experiment

Ready for more? Try **Experiment 2: Hive SQL Queries** to query data using SQL!

---

**Status**: ✅ Complete | **Difficulty**: Beginner | **Time**: 10-15 minutes

