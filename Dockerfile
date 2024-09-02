ARG TENSORFLOW_VERSION=2.17.0
FROM quay.io/jupyter/tensorflow-notebook:tensorflow-${TENSORFLOW_VERSION}

# must redefine as initial definition has gone out of scope
ARG TENSORFLOW_VERSION=2.17.0

LABEL "org.opencontainers.image.authors"="Hilmar Lapp <hilmar.lapp@duke.edu>"
LABEL "org.opencontainers.image.description"="Jupyter Lab (without GPU support) for Biostat courses"

# We follow the standard recommended recipe for custom builds off of Jupyter Docker Stacks
RUN mamba install --yes \
    'jupytext' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Uninstall tensorflow-cpu if it was installed on the x86_64 platform, and
# in that case reinstall as plain tensorflow.
#
# Otherwise we end up with a redundant installation because some dependency
# chains (such as keras-nlp->tensorflow-text->tensorflow) will result in a
# tensorflow requirement which doesn't resolve to tensorflow-cpu.
RUN [[ $(uname -m) = x86_64 ]] &&  \
    pip uninstall -y "tensorflow-cpu" && \
    pip install --no-cache-dir tensorflow==${TENSORFLOW_VERSION} && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Separate installation of PyTorch to use CPU-only version according to instructions
# See https://pytorch.org/get-started/locally/
RUN pip install --no-cache-dir --index-url 'https://download.pytorch.org/whl/cpu' \
    torch \
    torchvision \
    torchaudio && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Additional packages we may need
COPY requirements.txt /tmp/addon-requirements.txt
RUN pip install --no-cache-dir \
    -r /tmp/addon-requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# -------------------------------------------------------------------
# R kernel and packages for Jupyter, copying the recipe from
# https://github.com/jupyter/docker-stacks/blob/main/images/r-notebook/Dockerfile
# -------------------------------------------------------------------
USER root

# R pre-requisites
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# R packages including IRKernel which gets installed globally.
# r-e1071: dependency of the caret R package
# We take these verbatim from the Jupyter Docker Stacks R kernel Dockerfile:
# https://github.com/jupyter/docker-stacks/blob/main/images/r-notebook/Dockerfile
RUN mamba install --yes \
    'r-base' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-e1071' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-tidymodels' \
    'r-tidyverse' \
    'unixodbc' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Additional R packages potentially used in this course
RUN mamba install --yes \
    'r-gt' \
    'r-gtsummary' \
    'r-kableextra' \
    'r-microbenchmark' \
    'r-rcppeigen' \
    'r-rcppnumerical' \
    'r-tensorflow' \
    'r-keras' \
    'r-tfprobability' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
