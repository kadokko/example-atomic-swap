FROM ubuntu:bionic

ENV DEBCONF_NOWARNINGS yes
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update  -y \
&&  apt-get upgrade -y \
&&  apt-get clean
 
RUN apt-get install -y \
    git                \
    wget               \
    curl               \
    tar                \
    unzip              \
    sudo               \
    bzip2              \
    libssl-dev         \
    iputils-ping       \
    net-tools          \
&&  apt-get clean

RUN useradd -s /bin/bash -m jupyter
USER jupyter

ARG CONDA_HOME=/home/jupyter
WORKDIR $CONDA_HOME

# install conda
RUN wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O $CONDA_HOME/miniconda.sh \
&&  chmod u+x $CONDA_HOME/miniconda.sh \
&&  $CONDA_HOME/miniconda.sh -b -p $CONDA_HOME/miniconda
ENV PATH $PATH:$CONDA_HOME/miniconda/bin

# update conda
RUN conda update -y conda

# create conda virtual environment
RUN ver=$(conda search python | tail -1 | sed -E "s/\s+/ /g" | cut -f2 -d ' ') \
&&  envname="env$ver" \
&&  echo "env$ver" > ./.envname \
&&  conda create -y --name $envname python=$ver

# install jupyter & python libraries
ADD conf/requirements-conda.txt .
ADD conf/requirements-pip.txt .
RUN . $CONDA_HOME/miniconda/etc/profile.d/conda.sh \
&&  conda activate $envname \
&&  conda install -y jupyter \
&&  conda install -y --file requirements-conda.txt \
&&  pip install -r requirements-pip.txt

# configure jupyter
RUN . $CONDA_HOME/miniconda/etc/profile.d/conda.sh \
&&  notebook_conf="$CONDA_HOME/.jupyter/jupyter_notebook_config.py" \
&&  notebook_allow_ip="'0.0.0.0'" \
&&  notebook_dir="'/notebook'" \
&&  conda activate $(cat .envname) \
&&  jupyter notebook --generate-config -y \
&&  echo "c.NotebookApp.ip = $notebook_allow_ip"       >> $notebook_conf \
&&  echo "c.NotebookApp.notebook_dir = $notebook_dir"  >> $notebook_conf \
# not recommended
&&  echo "c.NotebookApp.token = ''"                    >> $notebook_conf \
&&  echo "c.NotebookApp.password = ''"                 >> $notebook_conf

# configure shell
RUN echo ". $CONDA_HOME/miniconda/etc/profile.d/conda.sh" >> ~/.bash_profile \
&&  echo 'conda init bash'                                >> ~/.bash_profile \
&&  echo 'conda activate $(cat .envname)'                 >> ~/.bashrc

EXPOSE 8888

CMD ["tail", "-f", "/dev/null"]
