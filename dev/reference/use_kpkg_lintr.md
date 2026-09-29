# Add a lintr configuration

Writes a `.lintr` with the default linters and a maximum line length of
80 characters. Run `lintr::lint_package()` to check the code.

## Usage

``` r
use_kpkg_lintr(overwrite = FALSE)
```

## Arguments

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The path of the file written, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_lintr()
} # }
```
