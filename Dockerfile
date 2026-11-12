FROM bde2020/hadoop-namenode:2.0.0-hadoop2.7.4-java8

USER root

# Install wget and other utilities
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Download and Install Sqoop
RUN wget -q https://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz -O /tmp/sqoop.tar.gz \
    && tar -xzf /tmp/sqoop.tar.gz -C /tmp \
    && mv /tmp/sqoop-1.4.7.bin__hadoop-2.6.0 /usr/local/sqoop \
    && rm -f /tmp/sqoop.tar.gz

# Download and Install MySQL Connector
RUN wget -q https://repo1.maven.org/maven2/mysql/mysql-connector-java/5.1.49/mysql-connector-java-5.1.49.jar -O /usr/local/sqoop/lib/mysql-connector-java-5.1.49.jar

# Download and Install Pig
RUN wget -q https://archive.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz -O /tmp/pig.tar.gz \
    && tar -xzf /tmp/pig.tar.gz -C /opt \
    && mv /opt/pig-0.17.0 /usr/local/pig \
    && rm -f /tmp/pig.tar.gz

# Configure environment variables
ENV SQOOP_HOME=/usr/local/sqoop
ENV PIG_HOME=/usr/local/pig
ENV HADOOP_COMMON_HOME=/opt/hadoop-2.7.4
ENV HADOOP_MAPRED_HOME=/opt/hadoop-2.7.4
ENV PATH="${PATH}:/usr/local/sqoop/bin:/usr/local/pig/bin"
ENV PIG_CLASSPATH=/opt/hadoop-2.7.4/etc/hadoop
