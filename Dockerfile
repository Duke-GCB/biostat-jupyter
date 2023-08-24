FROM jupyter/tensorflow-notebook:tensorflow-2.13.0

LABEL "org.opencontainers.image.authors"="Hilmar Lapp <hilmar.lapp@duke.edu>"
LABEL "org.opencontainers.image.description"="Jupyter Lab (without GPU support) for Biostat courses"

# We follow the standard recommended recipe for custom builds off of Jupyter Docker Stacks
RUN mamba install --yes \
    'tensorflow-probability' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"
