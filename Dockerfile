# see https://github.com/SwissDataScienceCenter/renkulab-docker
# to swap this image for the latest version available
FROM bioconductor/bioconductor_docker:RELEASE_3_19

# Uncomment and adapt if code is to be included in the image
# COPY src /code/src

# Uncomment and adapt if your R or python packages require extra linux (ubuntu) software
# e.g. the following installs apt-utils and vim; each pkg on its own line, all lines
# except for the last end with backslash '\' to continue the RUN line
#
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    vim \ 
    libtbb2 \
    libpng-dev \
    texlive-latex-base \
    texlive-fonts-recommended \
    libncurses-dev \
    default-jre \
    bedtools \
    libc6-amd64-cross

#RUN ln -s /usr/x86_64-linux-gnu/lib64 /lib64
#ENV LD_LIBRARY_PATH="/usr/lib/aarch64-linux-gnu/libdl.so.2/:/lib64/:/usr/x86_64-linux-gnu/lib/:/usr/x86_64-linux-gnu/lib/"

# install conda
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh 
#    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
#    && mkdir /root/.conda \
#    && bash Miniconda3-latest-Linux-x86_64.sh -b \
#    && rm -f Miniconda3-latest-Linux-x86_64.sh 
RUN conda --version

# downgrade python
RUN conda install python=3.9
RUN conda install -c bioconda -c conda-forge snakemake-minimal

RUN mkdir -p /root

# install packages manually
RUN wget -O /tmp/samtools-1.11.tar.bz2 https://github.com/samtools/samtools/releases/download/1.11/samtools-1.11.tar.bz2
RUN tar xvfj /tmp/samtools-1.11.tar.bz2 --directory=/tmp && /bin/rm /tmp/samtools-1.11.tar.bz2
WORKDIR "/tmp/samtools-1.11"
RUN ./configure --prefix=/usr && make && make install && /bin/rm -r /tmp/samtools-1.11

RUN wget -O /tmp/bowtie2-2.4.5-linux-x86_64.zip https://master.dl.sourceforge.net/project/bowtie-bio/bowtie2/2.4.5/bowtie2-2.4.5-linux-x86_64.zip
RUN unzip /tmp/bowtie2-2.4.5-linux-x86_64.zip -d /root && /bin/rm /tmp/bowtie2-2.4.5-linux-x86_64.zip
ENV PATH="/root/bowtie2-2.4.5-linux-x86_64/:${PATH}"
ARG PATH="/root/bowtie2-2.4.5-linux-x86_64/:${PATH}"

RUN wget -O /tmp/2.7.7a.tar.gz https://github.com/alexdobin/STAR/archive/2.7.7a.tar.gz
RUN tar -xzf /tmp/2.7.7a.tar.gz --directory=/root
WORKDIR "/root/STAR-2.7.7a/source"
RUN make STAR
ENV PATH="/root/STAR-2.7.7a/source:${PATH}"
ARG PATH="/root/STAR-2.7.7a/source:${PATH}"

RUN wget -O /tmp/minimap2-2.24_x64-linux.tar.bz2 https://github.com/lh3/minimap2/releases/download/v2.24/minimap2-2.24_x64-linux.tar.bz2
WORKDIR "/tmp"
RUN tar -jxvf /tmp/minimap2-2.24_x64-linux.tar.bz2 --directory=/root
ENV PATH="/root/minimap2-2.24_x64-linux/:${PATH}"
ARG PATH="/root/minimap2-2.24_x64-linux/:${PATH}"

RUN wget -O /tmp/fastqc_v0.11.9.zip https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.9.zip
RUN unzip -d /root /tmp/fastqc_v0.11.9.zip
RUN chmod +x /root/FastQC/fastqc
ENV PATH="/root/FastQC/:${PATH}"
ARG PATH="/root/FastQC/:${PATH}"

RUN curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.6.6.tar.gz -o /tmp/trim_galore.tar.gz
RUN tar xvzf /tmp/trim_galore.tar.gz --directory=/root
ENV PATH="/root/TrimGalore-0.6.6/:${PATH}"
ARG PATH="/root/TrimGalore-0.6.6/:${PATH}"

RUN wget -O /tmp/hisat2-2.2.1-Linux_x86_64.zip https://cloud.biohpc.swmed.edu/index.php/s/oTtGWbWjaxsQ2Ho/download
RUN unzip /tmp/hisat2-2.2.1-Linux_x86_64.zip -d /root
ENV PATH="/root/hisat2-2.2.1/:${PATH}"
ARG PATH="/root/hisat2-2.2.1/:${PATH}"

RUN wget -O /tmp/salmon-1.4.0_linux_x86_64.tar.gz https://github.com/COMBINE-lab/salmon/releases/download/v1.4.0/salmon-1.4.0_linux_x86_64.tar.gz
RUN tar xvf /tmp/salmon-1.4.0_linux_x86_64.tar.gz --directory=/root && /bin/rm /tmp/salmon-1.4.0_linux_x86_64.tar.gz
ENV PATH="/root/salmon-latest_linux_x86_64/bin/:${PATH}"
ARG PATH="/root/salmon-latest_linux_x86_64/bin/:${PATH}"

RUN curl http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig > /usr/bin/bedGraphToBigWig && chmod +x /usr/bin/bedGraphToBigWig

RUN echo 'pth <- Sys.getenv("PATH"); Sys.setenv(PATH = paste(pth, "/root/miniconda3/bin", sep = ":"))' >> /usr/local/lib/R/etc/Rprofile.site

# install the R dependencies
COPY install.R /tmp/
RUN R -f /tmp/install.R

# install the python dependencies
COPY requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt

WORKDIR "/home/rstudio"
RUN mkdir -p /home/rstudio/mnt

RUN chmod 755 /root

