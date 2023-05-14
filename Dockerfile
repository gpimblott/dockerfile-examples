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

# Install the Nvidia drives
RUN yum -y install bzip2 automake gcc-c++ pciutils elfutils-libelf-devel libglvnd-devel iptables firewalld vim bind-utils wge
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

RUN yum clean expire-cache
RUN yum -y install kernel-devel kernel-headers 

# Swap the main version of Python from 2.7 to 3.8
RUN pip3 install torch 
#--index-url https://download.pytorch.org/whl/cu100/
RUN pip3 install numpy tiktoken tqdm
# Pytorch needs a specific version of urllib3 otherwise there are ssl issues
RUN pip3 install --upgrade urllib3==1.26.15

# Clone nanoGPT
WORKDIR /install
RUN git clone https://github.com/karpathy/nanoGPT.git

# Download and convert the test dataset that we will train on
WORKDIR /install/nanoGPT
RUN python3 data/shakespeare_char/prepare.py

# Defaily command is to train the model
CMD ["python3", "train.py", "config/train_shakespeare_char.py"]

# Train the model - it should take ~ 3 mins on an A100 GPU
# See documentation at https://github.com/karpathy/nanoGPT
# RUN python3 train.py config/train_shakespeare_char.py
#
# Example of how to generate some sample data
# RUNpython3 sample.py --out_dir=out-shakespeare-char

