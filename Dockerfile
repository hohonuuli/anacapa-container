FROM ubuntu:16.04

ENV NSPAWN_BOOTSTRAP_IMAGE_SIZE=10GB

# install singularity config files
COPY anacapa /usr/local/anacapa
RUN cd /usr/local/anacapa/singularity-files && \
  cp -r ./ /

# set unlimited bash history
# nspawn needs resolv.conf to be set up for internet to work
# root password gets changed to 'root'
# RUN cd /usr/local/anacapa && \
#   echo "export HISTFILESIZE=" >> .bashrc && \
#   echo "export HISTSIZE=" >> .bashrc && \
#   rm -f /etc/resolv.conf && echo '8.8.8.8' > /etc/resolv.conf && \
#   echo "root:root" | chpasswd
  
# install apt + npm dependencies
RUN apt-get update && \
  apt-get install --yes \
      build-essential \
      software-properties-common \
      apt-transport-https \
      curl \
      wget \
      git \
      libssl-dev \
      libcurl4-openssl-dev \
      libxml2-dev \
      gfortran -y && \
  ln -s /bin/gzip /usr/bin/gzip && \
  wget -P /tmp/ "https://repo.continuum.io/miniconda/Miniconda2-4.5.4-Linux-x86_64.sh" && \
  bash "/tmp/Miniconda2-4.5.4-Linux-x86_64.sh" -b -p /usr/local/anacapa/miniconda && \
  echo "export PATH=/usr/local/anacapa/miniconda/bin:\$PATH" >> /usr/local/anacapa/.bashrc
 
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install -y nodejs && \
  npm i dat -g

# install python modules
RUN cd /usr/local/anacapa && \
  . /usr/local/anacapa/.bashrc && \
  pip install --upgrade pip && \
  pip install biopython cutadapt && \
  conda config --add channels r && \
  conda config --add channels defaults && \
  conda config --add channels conda-forge && \
  conda config --add channels bioconda && \
  conda install -yqc r-essentials=3.4.3 \
                     r-base=3.4.3 && \
  echo "export PATH=/usr/local/anacapa/miniconda/lib/R/bin:\$PATH" >> /usr/local/anacapa/.bashrc && \
  conda install -yqc libgit2 \
                     libssl \
                     bioconda \
                     bioconductor-impute \  
                     bioconductor-genefilter \
                     bioconductor-phyloseq \
                     bioconductor-dada2 \
                     ecopcr \
                     obitools \
                     blast \
                     bowtie2 \
                     libiconv \
                     cogent \
                     pandas 

RUN Rscript --vanilla /usr/local/anacapa/install-deps.R 

# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9 && \
#   add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu xenial/' && \
#   apt-get update && \
#   apt-get install --yes r-base=3.4.2-2xenial2 r-recommended=3.4.2-2xenial2 r-base-dev=3.4.2-2xenial2 r-base-html=3.4.2-2xenial2 r-doc-html=3.4.2-2xenial2 && \
#   Rscript --vanilla /usr/local/anacapa/install-deps.R 

# RUN apt-get install --yes libgit2

# RUN Rscript --vanilla /usr/local/anacapa/install-deps-dada2.R
#script ran fine to this point then stopped: 
#Step 8/9 : RUN  Rscript --vanilla install-deps.R---> Running in 5a5cbfc916dd
#/bin/sh: 1: Rscript: not found
#The command '/bin/sh -c Rscript --vanilla install-deps.R' returned a non-zero code: 127
#should Rscript --vanilla install-deps.R be added back to line 39 as in the Singularity file?

# install bundled software
RUN cd /usr/local/anacapa && \
  tar xzvf fastx_toolkit.tar.gz && \
  mkdir -p /u/local && \
  ln -s /usr/local/anacapa/apps /u/local/apps && \
  echo "export PATH=/usr/local/anacapa/apps/fastx_toolkit/0.0.13.2/gcc-4.4.6/bin/:\$PATH" >> .bashrc && \
  tar xzvf libgtextutils.tar.gz && \
  echo "/usr/local/anacapa/apps/libgtextutils/0.6.1/gcc-4.4.6/lib/" > /etc/ld.so.conf.d/libgtextutils.conf && \
  ldconfig && \
  tar xzvf bowtie2-2.2.9.tar.gz && \
  echo "export PATH=/usr/local/anacapa/apps/bowtie2/2.2.9:\$PATH" >> .bashrc && \
  cp muscle3.8.31_i86linux64 /usr/local/bin/muscle && \
  chmod +x /usr/local/bin/muscle