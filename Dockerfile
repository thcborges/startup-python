FROM python:3.9 as base
ARG UNAME=app
ARG UID=1000
ARG GID=1000

# Update repositories
RUN apt update && \
    apt upgrade -y && \
    apt autoremove -y && \
    apt install -y --no-install-recommends default-jdk && \
    apt clean && \
    rm -rf /var/tmp/* /tmp/* var/lib/apt/lists/*

# Install spark
ENV SPARK_HOME=/opt/spark
RUN wget https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz && \
    tar xf spark-3.1.1-bin-hadoop3.2.tgz && \
    mv spark-3.1.1-bin-hadoop3.2 $SPARK_HOME && \
    wget -P $SPARK_HOME/jars "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar" && \
    wget -P $SPARK_HOME/jars "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.11.375/aws-java-sdk-bundle-1.11.375.jar" && \
    wget -P $SPARK_HOME/jars "https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.19/postgresql-42.2.19.jar"

ENV PIP_DEFAULT_TIMEOUT=100 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1
ENV HOME=/home/$UNAME

# Create user
RUN groupadd -g $GID app && useradd -m -u $UID -g $GID -o -s /bin/bash $UNAME
RUN chown -R $UNAME $HOME
USER $UNAME


FROM base as development

ARG UNAME=app
ARG UID=1000
ARG GID=1000
# Install wget to download poetry
USER root
RUN apt install -y wget

USER $UNAME

RUN mkdir -p $HOME/app
WORKDIR $HOME/app

# Install poetry
ENV POETRY_VERSION=1.1.6
RUN wget -q https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py && \
    python get-poetry.py

# Set spark environoment
ENV SPARK_HOME=/opt/spark
ENV PATH=$HOME/.poetry/bin:/$HOME/.local/bin:$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV SPARK_LOCAL_IP="127.0.0.1"
ENV PYSPARK_PYTHON=/usr/local/bin/python
ENV PYSPARK_DRIVER_PYTHON=$HOME/.local/bin/jupyter-lab
ENV PYSPARK_DRIVER_PYTHON_OPTS="--ip=0.0.0.0 --no-browser"

# Build project
COPY . .
RUN poetry config virtualenvs.create false && \
    poetry install

CMD ["pyspark"]
