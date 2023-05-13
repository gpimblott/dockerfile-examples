FROM centos:7

RUN yum -y update

# Download and install Python 3.8.10
WORKDIR /install
RUN yum -y install gcc openssl-devel bzip2-devel libffi-devel git wget make
RUN wget https://www.python.org/ftp/python/3.8.10/Python-3.8.10.tgz && tar xzf Python-3.8.10.tgz && rm Python-3.8.10.tgz
WORKDIR /install/Python-3.8.10
RUN ./configure --enable-optimizations

RUN make -j $(nproc)
RUN make install

# Swap the main version of Python from 2.7 to 3.8
RUN pip3 install numpy torch tiktoken tqdm 
# Pytorch needs a specific version of urllib3 otherwise there are ssl issues
RUN pip3 install --upgrade urllib3==1.26.15

# Clone nanoGPT
WORKDIR /install
RUN git clone https://github.com/karpathy/nanoGPT.git

