# Default package author

The author written in the `Authors@R` field of the packages created with
[`create_pkg()`](https://kbosirany.github.io/kpkg.r/reference/create_pkg.md),
and the copyright holder of their MIT license. Another author can be
used by setting the option `kpkg.r.author` to a
[`utils::person()`](https://rdrr.io/r/utils/person.html), e.g. in your
`.Rprofile`.

## Usage

``` r
kpkg_author()
```

## Value

A [`utils::person()`](https://rdrr.io/r/utils/person.html) object.

## Examples

``` r
kpkg_author()
#> [1] "Kevin Bosirany Orlando <kevinbosirany@gmail.com> [aut, cre] (ORCID: <https://orcid.org/0009-0009-2784-3108>)"

# Use another author for the current session
old <- options(
  kpkg.r.author = person("Jane", "Doe", role = c("aut", "cre"))
)
kpkg_author()
#> [1] "Jane Doe [aut, cre]"
options(old)
```
