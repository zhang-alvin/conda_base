FROM erdc/ubuntu_base:latest

MAINTAINER Proteus Project <proteus@googlegroups.com>

#install miniconda, need to be root

USER root

SHELL ["bash", "-lc"]

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

#finished installing miniconda

# Configure environment
ENV SHELL /bin/bash
ENV NB_USER jovyan
ENV NB_UID 1000
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV PATH /opt/conda/bin:$PATH

# Create jovyan user with UID=1000 and in the 'users' group
RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER
RUN chown -R $NB_USER:users /home/$NB_USER

EXPOSE 8888
WORKDIR /home/$NB_USER

#build proteus as $NBUSER
USER $NB_USER

WORKDIR /home/$NB_USER

SHELL ["bash", "-lc"]

RUN git clone https://github.com/erdc/proteus && \
    cd proteus && \
    git checkout master && \
    conda env create -f environment-dev.yml && \
    conda clean --all -f -y && \ 
    rm -rf /home/$NB_USER/.cache && \
    cd ~ && \ 
    rm -rf proteus/

ARG conda_env=proteus-dev
RUN echo "source activate ${conda_env}" > ~/.bashrc

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH
ENV CONDA_DEFAULT_ENV ${conda_env}
