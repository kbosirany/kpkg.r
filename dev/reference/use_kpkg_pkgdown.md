# Add a pkgdown configuration

Writes a `_pkgdown.yml` with Bootstrap 5, the language of the site and
the automatic development mode: a version such as `0.1.0.9000` (branch
`dev`) is built into `docs/dev/`, a released version into `docs/`.

## Usage

``` r
use_kpkg_pkgdown(url = NULL, lang = "fr", overwrite = FALSE)
```

## Arguments

- url:

  URL of the site. By default, derived from the GitHub URL of the `URL`
  field of `DESCRIPTION` (`https://<owner>.github.io/<repo>/`); omitted
  if there is none.

- lang:

  Language of the site, e.g. `"fr"` or `"en"`.

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The path of the file written, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_pkgdown(lang = "en")
} # }
```
