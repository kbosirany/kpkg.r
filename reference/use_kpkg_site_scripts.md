# Add the scripts that build the pkgdown site

Copies into `dev/` the scripts run by the CI to build the site (the
workflow of
[`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md)
and the job of
[`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md)):

## Usage

``` r
use_kpkg_site_scripts(overwrite = FALSE)
```

## Arguments

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The paths of the files written, invisibly.

## Details

- `dev/build_site.R`: builds the pkgdown site, then renders the reports
  in it. The folder of the site is `KPKG_DEST` (default `docs`). It adds
  the navbar entries of the reports, `Reports [fr]` for the books ending
  with `-fr`, to those of `_pkgdown.yml`.

- `dev/render_reports.R`: renders each Quarto book of `reports/` (a
  folder with a `_quarto.yml`) in `<site>/reports/<book>/`, with an
  absolute output path, and checks that its `index.html` is there.
  Without it, a book rendered by `quarto render` lands in the book
  folder, and the link of the navbar to the report gives a 404 error.

The scripts are also the way to build the site locally:
`Rscript dev/build_site.R`. They need the Quarto CLI and the quarto R
package when there are books.

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_site_scripts()
} # }
```
