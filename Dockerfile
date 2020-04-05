FROM erdc/ubuntu_base:latest

MAINTAINER Proteus Project <proteus@googlegroups.com>

#install miniconda, need to be root

USER root

SHELL ["bash", "-lc"]

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
    #echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    #echo "conda activate base" >> ~/.bashrc

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
#RUN echo ". /etc/profile.d/conda.sh" >> ~/.bashrc 

RUN git clone https://github.com/erdc/proteus && \
    cd proteus && \
    git checkout master && \
    #git submodule update --init --recursive && \
    #./stack/hit/bin/hit init-home && \
    #./stack/hit/bin/hit remote add http://levant.hrwallingford.com/hashdist_src --objects="source" && \
    #make stack stack/hit/bin/hit stack/default.yaml && \
    #cd stack && \
    #./hit/bin/hit build -j 4 default.yaml -v && \
    #chmod u+rwX -R /home/$NB_USER/.hashdist/src && \
    #rm -rf rm -rf /home/$NB_USER/.hashdist/src && \
    conda env create -f environment-dev.yml && \
    rm -rf /home/$NB_USER/.cache && \
    #chmod u+rwX -R /home/$NB_USER/.hashdist/bld/chrono/*/share/chrono/data && \
    #rm -rf /home/$NB_USER/.hashdist/bld/chrono/*/share/chrono/data/* && \
    rm -rf /home/$NB_USER/proteus/.git && \
    rm -rf /home/$NB_USER/stack/.git && \
    rm -rf /home/$NB_USER/air-water-vv/.git && \
    rm -rf /home/$NB_USER/proteus/air-water-vv && \
    rm -rf /home/$NB_USER/proteus/build && \
    rm -rf /home/$NB_USER/proteus/stack/default

ARG conda_env=proteus-dev
RUN echo "source activate ${conda_env}" > ~/.bashrc

# prepend conda environment to path
ENV PATH $CONDA_DIR/envs/${conda_env}/bin:$PATH
ENV CONDA_DEFAULT_ENV ${conda_env}

#SHELL ["bash", "-lc"]
#RUN conda activate proteus-dev
