# Add a README with badges

`use_kpkg_readme()` writes a `README.Rmd` (with `README.md`, generated
from it) with the title, the description of the package, the
installation and a usage section, then adds the badges with
`use_kpkg_badges()`.

## Usage

``` r
use_kpkg_readme(lifecycle = "experimental", overwrite = FALSE)

use_kpkg_badges(lifecycle = "experimental")
```

## Arguments

- lifecycle:

  Lifecycle stage of the package, e.g. `"experimental"`, `"stable"`, see
  <https://lifecycle.r-lib.org/articles/stages.html>. `NULL` for no
  lifecycle badge.

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The path of `README.Rmd`, invisibly.

## Details

`use_kpkg_badges()` writes the badges between the lines
`<!-- badges: start -->` and `<!-- badges: end -->` of `README.Rmd`, so
that it also updates the README of an existing package. The block is
created after the title if there is none. Without `README.Rmd`, the
`README.md` is first converted to a `README.Rmd`. The badges depend on
the repositories found in the `URL` field of `DESCRIPTION`:

- GitHub repository: `R-CMD-check` and coverage
  ([Codecov](https://codecov.io)), see
  [`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md);

- GitLab repository (any other host): pipeline and coverage, see
  [`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md);

- lifecycle and license.

`README.md` is rebuilt with
[`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_readme.html)
when `README.Rmd` has R code, else with
[`rmarkdown::render()`](https://pkgs.rstudio.com/rmarkdown/reference/render.html)
when Pandoc is available. Otherwise, it is the text of `README.Rmd` and
is rebuilt by
[`devtools::build_readme()`](https://devtools.r-lib.org/reference/build_readme.html).

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_readme()
# Update the badges of an existing README
use_kpkg_badges()
} # }
```
