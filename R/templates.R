#' Templates shipped with kpkg.r
#'
#' Lists the files that the `use_kpkg_*()` functions copy into a package.
#' The templates are versioned with kpkg.r: every copied CI file starts with
#' a comment giving the kpkg.r version it comes from, so updating kpkg.r
#' then calling the `use_kpkg_*()` function again with `overwrite = TRUE`
#' updates the file.
#'
#' @return A data frame with the columns `template` (path in the
#'   `templates` folder of the installed package), `target` (path in the
#'   package created) and `fun` (function that copies it).
#' @export
#' @examples
#' kpkg_templates()
kpkg_templates <- function() {
  data.frame(
    template = c(
      "github/R-CMD-check.yaml",
      "github/pkgdown.yaml",
      "github/test-coverage.yaml",
      "gitlab/gitlab-ci.yml",
      "project/_pkgdown.yml",
      "project/build_site.R",
      "project/render_reports.R",
      "project/README.Rmd",
      "project/lintr"
    ),
    target = c(
      ".github/workflows/R-CMD-check.yaml",
      ".github/workflows/pkgdown.yaml",
      ".github/workflows/test-coverage.yaml",
      ".gitlab-ci.yml",
      "_pkgdown.yml",
      "dev/build_site.R",
      "dev/render_reports.R",
      "README.Rmd",
      ".lintr"
    ),
    fun = c(
      "use_kpkg_github",
      "use_kpkg_github",
      "use_kpkg_github",
      "use_kpkg_gitlab",
      "use_kpkg_pkgdown",
      "use_kpkg_site_scripts",
      "use_kpkg_site_scripts",
      "use_kpkg_readme",
      "use_kpkg_lintr"
    ),
    stringsAsFactors = FALSE
  )
}

#' Add the GitHub Actions workflows
#'
#' Copies the kpkg.r GitHub Actions workflows into `.github/workflows/`:
#'
#' * `R-CMD-check`: `R CMD check` on macOS, Windows and Ubuntu (R devel,
#'   release and oldrel-1), on pushes to `main` and `dev` and on pull
#'   requests.
#' * `pkgdown`: builds the pkgdown site and deploys it on the `gh-pages`
#'   branch, the site of `main` at the root and the site of `dev` in `/dev`.
#'   It runs `dev/build_site.R`, see [use_kpkg_site_scripts()], which also
#'   renders the Quarto books of `reports/` in the site.
#' * `test-coverage`: test coverage with covr, uploaded to Codecov (secret
#'   `CODECOV_TOKEN`), for the coverage badge of [use_kpkg_readme()].
#'
#' @param workflows Workflows to add.
#' @param overwrite Whether to replace existing files, e.g. to update them
#'   to the templates of the installed kpkg.r version.
#'
#' @return The paths of the files written, invisibly.
#' @seealso [use_kpkg_gitlab()] for the GitLab CI equivalent.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_github()
#' # Update the workflows after updating kpkg.r
#' use_kpkg_github(overwrite = TRUE)
#' }
use_kpkg_github <- function(workflows = c("R-CMD-check", "pkgdown",
                                          "test-coverage"),
                            overwrite = FALSE) {
  workflows <- match.arg(workflows, several.ok = TRUE)
  usethis::use_build_ignore("^\\.github$", escape = FALSE)
  if ("pkgdown" %in% workflows) {
    use_kpkg_site_scripts()
  }
  written <- vapply(workflows, function(w) {
    copy_template(
      file.path("github", paste0(w, ".yaml")),
      file.path(".github", "workflows", paste0(w, ".yaml")),
      overwrite = overwrite
    )
  }, character(1))
  invisible(written[!is.na(written)])
}

#' Add the GitLab CI configuration
#'
#' Copies the kpkg.r `.gitlab-ci.yml`, the GitLab CI equivalent of the
#' workflows of [use_kpkg_github()]:
#'
#' * `check`: `R CMD check` with R release and R devel (Docker images
#'   `rocker/r-ver`), on every branch.
#' * `coverage`: test coverage with covr. GitLab reads the percentage in the
#'   log for the coverage badge of [use_kpkg_readme()].
#' * `pages`: pkgdown site with GitLab Pages, the site of `main` at the root
#'   and the site of `dev` in `/dev`. As GitLab Pages only keeps the last
#'   deployment, the job builds both branches every time. It runs
#'   `dev/build_site.R`, see [use_kpkg_site_scripts()], which also renders
#'   the Quarto books of `reports/` in the site.
#'
#' @inheritParams use_kpkg_github
#' @return The path of the file written, invisibly.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_gitlab()
#' }
use_kpkg_gitlab <- function(overwrite = FALSE) {
  usethis::use_build_ignore(".gitlab-ci.yml")
  use_kpkg_site_scripts()
  written <- copy_template(
    "gitlab/gitlab-ci.yml", ".gitlab-ci.yml",
    overwrite = overwrite
  )
  invisible(written[!is.na(written)])
}

#' Add a pkgdown configuration
#'
#' Writes a `_pkgdown.yml` with Bootstrap 5, the language of the site and
#' the automatic development mode: a version such as `0.1.0.9000` (branch
#' `dev`) is built into `docs/dev/`, a released version into `docs/`.
#'
#' @param url URL of the site. By default, derived from the GitHub URL of
#'   the `URL` field of `DESCRIPTION`
#'   (`https://<owner>.github.io/<repo>/`); omitted if there is none.
#' @param lang Language of the site, e.g. `"fr"` or `"en"`.
#' @inheritParams use_kpkg_github
#' @return The path of the file written, invisibly.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_pkgdown(lang = "en")
#' }
use_kpkg_pkgdown <- function(url = NULL, lang = "fr", overwrite = FALSE) {
  if (is.null(url)) {
    url <- github_pages_url(usethis::proj_get())
  }
  usethis::use_build_ignore(c("_pkgdown.yml", "docs", "pkgdown"))
  usethis::use_git_ignore("docs")
  use_kpkg_site_scripts()
  written <- copy_template(
    "project/_pkgdown.yml", "_pkgdown.yml",
    data = list(url = url, lang = lang),
    overwrite = overwrite
  )
  invisible(written[!is.na(written)])
}

#' Add the scripts that build the pkgdown site
#'
#' Copies into `dev/` the scripts run by the CI to build the site (the
#' workflow of [use_kpkg_github()] and the job of [use_kpkg_gitlab()]):
#'
#' * `dev/build_site.R`: builds the pkgdown site, then renders the reports in
#'   it. The folder of the site is `KPKG_DEST` (default `docs`). It adds the
#'   navbar entries of the reports, `Reports [fr]` for the books ending with
#'   `-fr`, to those of `_pkgdown.yml`.
#' * `dev/render_reports.R`: renders each Quarto book of `reports/` (a folder
#'   with a `_quarto.yml`) in `<site>/reports/<book>/`, with an absolute
#'   output path, and checks that its `index.html` is there. Without it, a
#'   book rendered by `quarto render` lands in the book folder, and the link
#'   of the navbar to the report gives a 404 error.
#'
#' The scripts are also the way to build the site locally:
#' `Rscript dev/build_site.R`. They need the Quarto CLI and the quarto R
#' package when there are books.
#'
#' @inheritParams use_kpkg_github
#' @return The paths of the files written, invisibly.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_site_scripts()
#' }
use_kpkg_site_scripts <- function(overwrite = FALSE) {
  usethis::use_build_ignore("^dev$", escape = FALSE)
  written <- vapply(c("build_site.R", "render_reports.R"), function(script) {
    copy_template(
      file.path("project", script), file.path("dev", script),
      overwrite = overwrite
    )
  }, character(1))
  invisible(written[!is.na(written)])
}

#' Add a lintr configuration
#'
#' Writes a `.lintr` with the default linters and a maximum line length of
#' 80 characters. Run `lintr::lint_package()` to check the code.
#'
#' @inheritParams use_kpkg_github
#' @return The path of the file written, invisibly.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_lintr()
#' }
use_kpkg_lintr <- function(overwrite = FALSE) {
  usethis::use_build_ignore(".lintr")
  written <- copy_template(
    "project/lintr", ".lintr",
    overwrite = overwrite, header = FALSE
  )
  invisible(written[!is.na(written)])
}

# Copies a template into the active project. `{{name}}` placeholders are
# replaced by `data$name`; a line whose placeholder is NULL is dropped.
# Returns the path written, or NA if the file exists and is kept.
copy_template <- function(template, target, data = list(), overwrite = FALSE,
                          header = TRUE) {
  src <- system.file("templates", template, package = "kpkg.r")
  if (!nzchar(src)) {
    stop("Unknown template: ", template, call. = FALSE)
  }
  path <- file.path(usethis::proj_get(), target)
  if (file.exists(path) && !overwrite) {
    message(
      "Kept existing ", target, " (use `overwrite = TRUE` to replace it)."
    )
    return(NA_character_)
  }
  lines <- readLines(src, encoding = "UTF-8", warn = FALSE)
  lines <- fill_placeholders(lines, data)
  if (header) {
    lines <- c(
      paste0(
        "# Template kpkg.r ", utils::packageVersion("kpkg.r"), ": ",
        template
      ),
      lines
    )
  }
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  con <- file(path, open = "wb")
  on.exit(close(con))
  writeLines(enc2utf8(lines), con, useBytes = TRUE)
  message("Wrote ", target)
  path
}

fill_placeholders <- function(lines, data) {
  matches <- regmatches(lines, gregexpr("\\{\\{\\w+\\}\\}", lines))
  keys <- unique(unlist(matches))
  for (key in keys) {
    name <- gsub("[{}]", "", key)
    value <- data[[name]]
    has_key <- grepl(key, lines, fixed = TRUE)
    if (is.null(value)) {
      # Drop the line and the blank line after it
      drop <- which(has_key)
      blank <- drop + 1L
      blank <- blank[blank <= length(lines) & !nzchar(lines[blank])]
      lines <- lines[-c(drop, blank)]
    } else {
      lines <- gsub(key, value, lines, fixed = TRUE)
    }
  }
  lines
}

# https://<owner>.github.io/<repo>/ from the GitHub URL of DESCRIPTION
github_pages_url <- function(path) {
  desc_file <- file.path(path, "DESCRIPTION")
  if (!file.exists(desc_file)) {
    return(NULL)
  }
  urls <- read.dcf(desc_file, fields = "URL")[1, 1]
  if (is.na(urls)) {
    return(NULL)
  }
  urls <- trimws(strsplit(urls, ",")[[1]])
  pattern <- "^https://github\\.com/([^/]+)/([^/]+?)/?$"
  gh <- grep(pattern, urls, value = TRUE)
  if (length(gh) == 0) {
    return(NULL)
  }
  owner <- sub(pattern, "\\1", gh[1])
  repo <- sub(pattern, "\\2", gh[1])
  paste0("https://", tolower(owner), ".github.io/", repo, "/")
}
