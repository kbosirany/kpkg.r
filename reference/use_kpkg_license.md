# Set the kpkg.r license on a package

Applies the default kpkg.r license, the AGPL (\>= 3), to the active
package: `License: AGPL (>= 3)` in `DESCRIPTION` and the license text in
`LICENSE.md`.
[`create_pkg()`](https://kbosirany.github.io/kpkg.r/reference/create_pkg.md)
calls it for new packages; call it in a package created with an earlier
version of kpkg.r (MIT license) to update it.

## Usage

``` r
use_kpkg_license(overwrite = FALSE)
```

## Arguments

- overwrite:

  Whether to replace a license that kpkg.r did not set.

## Value

The path of `LICENSE.md`, invisibly, or `NULL` if the package already
has the AGPL (\>= 3) license.

## Details

The `LICENSE` file that goes with `MIT + file LICENSE` (year and
copyright holder only) is removed, as the AGPL needs none.

Only licenses that kpkg.r itself can have set are replaced: the
placeholder written by
[`usethis::create_package()`](https://usethis.r-lib.org/reference/create_package.html)
and `MIT + file LICENSE`, the former default of kpkg.r. Any other
license is left alone unless `overwrite = TRUE`, as changing the license
of a package is a decision of its copyright holders. Mentions of the old
license in other files (README, vignettes, headers) are not changed.

## See also

[`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md)
and the other `use_kpkg_*()` functions to update the other files created
by kpkg.r.

## Examples

``` r
if (FALSE) { # \dontrun{
# In a package created with an earlier version of kpkg.r
use_kpkg_license()

# Replace any other license (e.g. GPL-3), knowing what it implies
use_kpkg_license(overwrite = TRUE)
} # }
```
