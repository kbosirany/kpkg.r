#' Create a package with the kpkg.r conventions
#'
#' A wrapper around [usethis::create_package()] that also sets up:
#'
#' * the author ([kpkg_author()]) in `Authors@R`;
#' * the `URL` and `BugReports` fields for a GitHub repository;
#' * the MIT license, with the author as copyright holder;
#' * roxygen2 with markdown, testthat (3rd edition) and `NEWS.md`;
#' * a `README.Rmd` with the badges ([use_kpkg_readme()]);
#' * a `.lintr` limiting lines to 80 characters ([use_kpkg_lintr()]);
#' * a `_pkgdown.yml` ([use_kpkg_pkgdown()]);
#' * the continuous integration for GitHub ([use_kpkg_github()]) and/or
#'   GitLab ([use_kpkg_gitlab()]).
#'
#' The version of a new package is `0.0.0.9000`. See
#' `vignette("workflow", package = "kpkg.r")` for the branch and version
#' conventions.
#'
#' @param path Path of the new package. Its last component is the package
#'   name.
#' @param title,description `Title` and `Description` fields of
#'   `DESCRIPTION`. Left as placeholders to edit if `NULL`.
#' @param github_owner GitHub user or organisation hosting the package,
#'   used for the `URL`, `BugReports` and pkgdown site URL. `NULL` to leave
#'   them out. Defaults to the option `kpkg.r.github_owner`, or
#'   `"kbosirany"`.
#' @param ci Continuous integration to add: `"github"`, `"gitlab"`, both or
#'   none (`character()`).
#' @param lang Language of the pkgdown site.
#' @param git Whether to initialise a Git repository.
#' @param rstudio Whether to create an RStudio project file (`.Rproj`).
#' @param open Whether to open the new package, in a new RStudio session if
#'   possible.
#'
#' @return The path of the package, invisibly.
#' @export
#' @examples
#' \dontrun{
#' create_pkg("~/projets/monpkg", title = "Do Something Useful")
#'
#' # Package hosted on a GitLab forge only
#' create_pkg("~/projets/monpkg", github_owner = NULL, ci = "gitlab")
#' }
create_pkg <- function(path,
                       title = NULL,
                       description = NULL,
                       github_owner = getOption(
                         "kpkg.r.github_owner", "kbosirany"
                       ),
                       ci = c("github", "gitlab"),
                       lang = "fr",
                       git = TRUE,
                       rstudio = TRUE,
                       open = interactive()) {
  if (length(ci) > 0) {
    ci <- match.arg(ci, c("github", "gitlab"), several.ok = TRUE)
  }
  name <- basename(normalizePath(path, mustWork = FALSE))
  author <- kpkg_author()

  fields <- list(`Authors@R` = authors_field(author))
  if (!is.null(title)) {
    fields$Title <- title
  }
  if (!is.null(description)) {
    fields$Description <- description
  }
  if (!is.null(github_owner)) {
    repo <- paste0("https://github.com/", github_owner, "/", name)
    site <- paste0("https://", tolower(github_owner), ".github.io/", name)
    fields$URL <- paste0(repo, ", ", site, "/")
    fields$BugReports <- paste0(repo, "/issues")
  }

  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  path <- usethis::create_package(
    path,
    fields = fields,
    rstudio = rstudio,
    roxygen = TRUE,
    open = FALSE
  )
  usethis::local_project(path, quiet = TRUE)

  usethis::use_mit_license(copyright_holder = author_name(author))
  usethis::use_testthat(3)
  usethis::use_news_md(open = FALSE)
  use_kpkg_lintr()
  use_kpkg_pkgdown(lang = lang)
  use_kpkg_readme()
  if ("github" %in% ci) {
    use_kpkg_github()
  }
  if ("gitlab" %in% ci) {
    use_kpkg_gitlab()
  }
  # usethis reformats Authors@R on one long line: restore one argument per
  # line
  desc::desc_set(
    `Authors@R` = fields$`Authors@R`,
    file = path,
    normalize = FALSE
  )
  if (git) {
    usethis::use_git()
  }

  if (open) {
    usethis::proj_activate(path)
  }
  invisible(path)
}
