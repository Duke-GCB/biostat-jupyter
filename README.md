# Jupyter Lab containers for Biostat courses

Builds and deploys customized Jupyter Lab Docker container images.

The images are currently built off of the [jupyter/tensorflow-notebook`](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-tensorflow-notebook) containers from the (excellent) [Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/) project.

Customization includes adding the following:
- [jupytext](https://jupytext.readthedocs.io/)
- [PyTorch](https://pytorch.org)
- Additional Python packages (see [`common-requirements.txt`](common-requirements.txt) and those specific to [Tensorflow 2.17+](requirements.tf-2.17.0.txt) and [Tensorflow 2.15.0](requirements.tf-2.15.0.txt))
- [R kernel for Jupyter](https://irkernel.github.io) and a variety of commonly used R packages mirroring the recipe for the [Docker Stacks R Notebook](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#jupyter-r-notebook), plus the R packages for tensorflow, keras, and tf-probability.

For all additions, we follow the recipes from the Docker Stacks container definitions to the extent possible.  

The following tags are available:
- The course year as a four-digit number (e.g., `2024`)
- Tags with suffix `-py` include _only_ the Python additions in the list above, i.e., do not include the R kernel and packages.
- Tags `-cuda` (and `-cuda-py`) in the suffix include support for GPUs; they are built off of the [CUDA-supporting Docker Stacks tensorflow image](https://jupyter-docker-stacks.readthedocs.io/en/latest/using/selecting.html#cuda-enabled-variant) and thus include the CUDA libraries (PyTorch is installed with CUDA v12.1). Note that tags without `-cuda` in the suffix _do not_ have GPU support.
- Tags with suffix `-tf2.17.0` (and tag `latest`) use Tensorflow 2.17.0 (and thus Keras v3); those with suffix `-tf2.15.0` use Tensorflow 2.15.0 (and thus Keras v2.15.0).
    * Note that code developed for Keras v2 [may need to be migrated](https://keras.io/guides/migrating_to_keras_3/) to run under Keras v3.
    * Alternatively, use the (pre-installed) `tf-keras` package (which creates a Keras v2-compatible API in `tensorflow.keras`) under Tensorflow 2.16+, by issuing the following _before_ importing Tensorflow:
      ```python
      import os;
      os.environ["TF_USE_LEGACY_KERAS"]=”1”
      ```

For prefixes `latest` and `2024`, the base image used is built with Tensorflow 2.17+, and thus Keras v3.x.

Currently the Python-only images (tags with `-py` suffix) _without_ GPU support (no `-cuda` in the suffix) are built multi-platform (i.e., including the [`aarch64`/`arm64`](https://en.wikipedia.org/wiki/AArch64) platform).
- Note that certain Python packages are unavailable in installable form for the `aarch64` platform (such as keras-nlp and tensorflow-text); if keras-nlp (which is installable on `arm64`) is needed on an Apple Silicon machine, consider creating a local conda environment instead of using the container.
- Docker on Apple Silicon Macs does not provide access to the [Metal API](https://developer.apple.com/metal/), hence there is no benefit to the `-cuda` image on macOS.