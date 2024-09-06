ARG BASE_TAG=latest-py
FROM ghcr.io/duke-gcb/biostat-jupyter:${BASE_TAG}

LABEL org.opencontainers.image.description="Combines the Docker Stacks tensorflow-notebook, pytorch-notebook, and r-notebook containers plus jupytext and custom package additions."

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
