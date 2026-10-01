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
#>                    template                               target
#> 1   github/R-CMD-check.yaml   .github/workflows/R-CMD-check.yaml
#> 2       github/pkgdown.yaml       .github/workflows/pkgdown.yaml
#> 3 github/test-coverage.yaml .github/workflows/test-coverage.yaml
#> 4      gitlab/gitlab-ci.yml                       .gitlab-ci.yml
#> 5      project/_pkgdown.yml                         _pkgdown.yml
#> 6      project/build_site.R                     dev/build_site.R
#> 7  project/render_reports.R                 dev/render_reports.R
#> 8        project/README.Rmd                           README.Rmd
#> 9             project/lintr                               .lintr
#>                     fun
#> 1       use_kpkg_github
#> 2       use_kpkg_github
#> 3       use_kpkg_github
#> 4       use_kpkg_gitlab
#> 5      use_kpkg_pkgdown
#> 6 use_kpkg_site_scripts
#> 7 use_kpkg_site_scripts
#> 8       use_kpkg_readme
#> 9        use_kpkg_lintr
```
