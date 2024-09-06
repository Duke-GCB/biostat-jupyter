# Jupyter Lab containers for Biostat courses

Builds and deploys customized Jupyter Lab Docker container images.

The images are currently built off of the [jupyter/tensorflow-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-tensorflow-notebook) containers from the (excellent) [Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/) project.

Customization includes adding the following:
- [jupytext](https://jupytext.readthedocs.io/)
- [PyTorch](https://pytorch.org)
- Additional Python packages from [`requirements.txt`](requirements.txt)
- [R kernel for Jupyter](https://irkernel.github.io) and a variety of commonly used R packages mirroring the recipe for the [Docker Stacks R Notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-r-notebook), plus the R packages for tensorflow, keras, and tf-probability.

For all additions, we follow the recipes from the Docker Stacks container definitions to the extent possible.  

The following tags are available:
- The course year as a four-digit number (e.g., `2024`)
- Tags with suffix `-py` include _only_ the Python additions in the list above.
- Tags with suffix `-cuda` (or `-cuda-py`) include support for GPUs; they are built off of the [CUDA-supporting Docker Stacks tensorflow image](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#cuda-enabled-variant) and thus include the CUDA libraries (PyTorch is installed with CUDA v12.1). Note that tags without `-cuda` in the suffix _do not_ have GPU support.

For prefixes `latest` and `2024`, the base image used is built with Tensorflow 2.17+, and thus Keras v3.x.

Currently only the Python-only images (tags with `-py` suffix) without GPU support (no `-cuda` in the suffix) are built multi-platform. (Note that Docker on Apple Silicon Macs does not provide access to the [Metal API](https://developer.apple.com/metal/), hence there is no benefit to the `-cuda` image on macOS.)