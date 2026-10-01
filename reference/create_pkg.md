# Create a package with the kpkg.r conventions

A wrapper around
[`usethis::create_package()`](https://usethis.r-lib.org/reference/create_package.html)
that also sets up:

## Usage

``` r
create_pkg(
  path,
  title = NULL,
  description = NULL,
  github_owner = getOption("kpkg.r.github_owner", "kbosirany"),
  ci = c("github", "gitlab"),
  lang = "fr",
  git = TRUE,
  rstudio = TRUE,
  open = interactive()
)
```

## Arguments

- path:

  Path of the new package. Its last component is the package name.

- title, description:

  `Title` and `Description` fields of `DESCRIPTION`. Left as
  placeholders to edit if `NULL`.

- github_owner:

  GitHub user or organisation hosting the package, used for the `URL`,
  `BugReports` and pkgdown site URL. `NULL` to leave them out. Defaults
  to the option `kpkg.r.github_owner`, or `"kbosirany"`.

- ci:

  Continuous integration to add: `"github"`, `"gitlab"`, both or none
  ([`character()`](https://rdrr.io/r/base/character.html)).

- lang:

  Language of the pkgdown site.

- git:

  Whether to initialise a Git repository.

- rstudio:

  Whether to create an RStudio project file (`.Rproj`).

- open:

  Whether to open the new package, in a new RStudio session if possible.

## Value

The path of the package, invisibly.

## Details

- the author
  ([`kpkg_author()`](https://kbosirany.github.io/kpkg.r/reference/kpkg_author.md))
  in `Authors@R`;

- the `URL` and `BugReports` fields for a GitHub repository;

- the MIT license, with the author as copyright holder;

- roxygen2 with markdown, testthat (3rd edition) and `NEWS.md`;

- a `README.Rmd` with the badges
  ([`use_kpkg_readme()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_readme.md));

- a `.lintr` limiting lines to 80 characters
  ([`use_kpkg_lintr()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_lintr.md));

- a `_pkgdown.yml`
  ([`use_kpkg_pkgdown()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_pkgdown.md));

- the continuous integration for GitHub
  ([`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md))
  and/or GitLab
  ([`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md)).

The version of a new package is `0.0.0.9000`. See
[`vignette("workflow", package = "kpkg.r")`](https://kbosirany.github.io/kpkg.r/articles/workflow.md)
for the branch and version conventions.

## Examples

``` r
if (FALSE) { # \dontrun{
create_pkg("~/projets/monpkg", title = "Do Something Useful")

# Package hosted on a GitLab forge only
create_pkg("~/projets/monpkg", github_owner = NULL, ci = "gitlab")
} # }
```
