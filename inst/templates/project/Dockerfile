# Image of the CI jobs (GitHub Actions and GitLab CI) and of the dev
# container: R CMD check, the test coverage and the pkgdown site run in the
# same environment in the CI and locally.
#
# Build argument R_VERSION: tag of rocker/r-ver ("latest", "devel", "4.5.1").
# The dependencies of the package are not in the image: the CI jobs and the
# dev container install them with pak::local_install_dev_deps().
ARG R_VERSION=latest
FROM rocker/r-ver:${R_VERSION}

# PKG_SYSREQS: pak installs the system requirements of the R packages
ENV PKG_SYSREQS=true \
    R_KEEP_PKG_SOURCE=yes \
    _R_CHECK_CRAN_INCOMING_=false

RUN apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    pandoc qpdf git libcurl4-openssl-dev libssl-dev libxml2-dev pkg-config \
  && rm -rf /var/lib/apt/lists/*

# pak from the binaries of r-lib: R-devel has no binaries on CRAN, and
# building pak from the sources takes about 3 minutes
RUN Rscript -e ' \
    pak_repo <- sprintf( \
      "https://r-lib.github.io/p/pak/stable/%s/%s/%s", \
      .Platform$pkgType, R.Version()$os, R.Version()$arch \
    ); \
    install.packages("pak", repos = pak_repo); \
    if (!requireNamespace("pak", quietly = TRUE)) install.packages("pak")'

# Tools of the CI jobs, and devtools for the dev container
RUN Rscript -e 'pak::pkg_install(c( \
      "rcmdcheck", "covr", "xml2", "pkgdown", "quarto", "devtools" \
    )); pak::cache_clean()'

# Quarto CLI, to render the books of `reports/` (rocker images script)
RUN /rocker_scripts/install_quarto.sh latest \
  && rm -rf /var/lib/apt/lists/*
