# Add the GitHub Actions workflows

Copies the kpkg.r GitHub Actions workflows into `.github/workflows/`:

## Usage

``` r
use_kpkg_github(
  workflows = c("R-CMD-check", "pkgdown", "test-coverage"),
  overwrite = FALSE
)
```

## Arguments

- workflows:

  Workflows to add.

- overwrite:

  Whether to replace existing files, e.g. to update them to the
  templates of the installed kpkg.r version.

## Value

The paths of the files written, invisibly.

## Details

- `R-CMD-check`: `R CMD check` on macOS, Windows and Ubuntu (R devel,
  release and oldrel-1), on pushes to `main` and `dev` and on pull
  requests.

- `pkgdown`: builds the pkgdown site and deploys it on the `gh-pages`
  branch, the site of `main` at the root and the site of `dev` in
  `/dev`. It runs `dev/build_site.R`, see
  [`use_kpkg_site_scripts()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_site_scripts.md),
  which also renders the Quarto books of `reports/` in the site.

- `test-coverage`: test coverage with covr, uploaded to Codecov (secret
  `CODECOV_TOKEN`), for the coverage badge of
  [`use_kpkg_readme()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_readme.md).

## See also

[`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md)
for the GitLab CI equivalent.

## Examples

``` r
if (FALSE) { # \dontrun{
use_kpkg_github()
# Update the workflows after updating kpkg.r
use_kpkg_github(overwrite = TRUE)
} # }
```
