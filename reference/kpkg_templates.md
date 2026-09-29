# Templates shipped with kpkg.r

Lists the files that the `use_kpkg_*()` functions copy into a package.
The templates are versioned with kpkg.r: every copied CI file starts
with a comment giving the kpkg.r version it comes from, so updating
kpkg.r then calling the `use_kpkg_*()` function again with
`overwrite = TRUE` updates the file.

## Usage

``` r
kpkg_templates()
```

## Value

A data frame with the columns `template` (path in the `templates` folder
of the installed package), `target` (path in the package created) and
`fun` (function that copies it).

## Examples

``` r
kpkg_templates()
#>                  template                             target              fun
#> 1 github/R-CMD-check.yaml .github/workflows/R-CMD-check.yaml  use_kpkg_github
#> 2     github/pkgdown.yaml     .github/workflows/pkgdown.yaml  use_kpkg_github
#> 3    gitlab/gitlab-ci.yml                     .gitlab-ci.yml  use_kpkg_gitlab
#> 4    project/_pkgdown.yml                       _pkgdown.yml use_kpkg_pkgdown
#> 5           project/lintr                             .lintr   use_kpkg_lintr
```
