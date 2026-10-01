# Add the GitLab CI configuration

Copies the kpkg.r `.gitlab-ci.yml`, the GitLab CI equivalent of the
workflows of
[`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md):

## Usage

``` r
use_kpkg_gitlab(overwrite = FALSE)
```

## Arguments

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The path of the file written, invisibly.

## Details

- `check`: `R CMD check` with R release and R devel (Docker images
  `rocker/r-ver`), on every branch.

- `pages`: pkgdown site with GitLab Pages, the site of `main` at the
  root and the site of `dev` in `/dev`. As GitLab Pages only keeps the
  last deployment, the job builds both branches every time. It runs
  `dev/build_site.R`, see
  [`use_kpkg_site_scripts()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_site_scripts.md),
  which also renders the Quarto books of `reports/` in the site.

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_gitlab()
} # }
```
