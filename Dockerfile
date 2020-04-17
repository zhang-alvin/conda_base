FROM erdc/ubuntu_base:latest

MAINTAINER Proteus Project <proteus@googlegroups.com>

#install miniconda, need to be root

USER root

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    rm -rf /opt/conda/pkgs/*

#finished installing miniconda

# Configure environment
ENV SHELL /bin/bash
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV PATH /opt/conda/bin:$PATH

WORKDIR /opt/proteus

SHELL ["bash", "-lc"]

RUN git clone https://github.com/erdc/proteus && \
    cd proteus && \
    git checkout master && \
    conda env create -f environment-dev.yml && \
    conda clean --all -f -y && \ 
    rm -rf /opt/conda/pkgs/* && \
    rm -rf /home/$NB_USER/.cache && \
    rm -rf ~/.conda/envs/proteus-dev/share/chrono/data/* && \
    cd ~ && \ 
    rm -rf proteus/

ARG conda_env=proteus-dev
RUN echo "source activate ${conda_env}" > ~/.bashrc

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH
ENV CONDA_DEFAULT_ENV ${conda_env}
