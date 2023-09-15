FROM jupyter/tensorflow-notebook:tensorflow-2.13.0

LABEL "org.opencontainers.image.authors"="Hilmar Lapp <hilmar.lapp@duke.edu>"
LABEL "org.opencontainers.image.description"="Jupyter Lab (without GPU support) for Biostat courses"

# We follow the standard recommended recipe for custom builds off of Jupyter Docker Stacks
RUN mamba install --yes \
    'jupytext' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# For some reason if we use mamba to install this, it ends up downgrading
# Tensorflow, even when pinning it to >=2.13.0.
RUN pip3 install --no-cache-dir \
    tensorflow-probability && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Separate installation of PyTorch to use CPU-only version according to instructions
# See https://pytorch.org/get-started/locally/
RUN pip3 install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cpu && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# -------------------------------------------------------------------
# R kernel and packages for Jupyter, copying the recipe from
#
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

# Additional R packages used in this course
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
