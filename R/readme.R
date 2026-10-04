#' Add a README with badges
#'
#' `use_kpkg_readme()` writes a `README.Rmd` (with `README.md`, generated
#' from it) with the title, the description of the package, the installation
#' and a usage section, then adds the badges with `use_kpkg_badges()`.
#'
#' `use_kpkg_badges()` writes the badges between the lines
#' `<!-- badges: start -->` and `<!-- badges: end -->` of `README.Rmd`, so
#' that it also updates the README of an existing package. The block is
#' created after the title if there is none. Without `README.Rmd`, the
#' `README.md` is first converted to a `README.Rmd`. The badges depend on
#' the repositories found in the `URL` field of `DESCRIPTION`:
#'
#' * GitHub repository: `R-CMD-check` and coverage ([Codecov](
#'   https://codecov.io)), see [use_kpkg_github()];
#' * GitLab repository (any other host): pipeline and coverage, see
#'   [use_kpkg_gitlab()];
#' * lifecycle and license.
#'
#' `README.md` is rebuilt with `devtools::build_readme()` when `README.Rmd`
#' has R code, else with [rmarkdown::render()] when Pandoc is available.
#' Otherwise, it is the text of `README.Rmd` and is rebuilt by
#' `devtools::build_readme()`.
#'
#' @inheritParams use_kpkg_github
#' @param lifecycle Lifecycle stage of the package, e.g. `"experimental"`,
#'   `"stable"`, see <https://lifecycle.r-lib.org/articles/stages.html>.
#'   `NULL` for no lifecycle badge.
#' @return The path of `README.Rmd`, invisibly.
#' @export
#' @examples
#' \dontrun{
#' use_kpkg_readme()
#' # Update the badges of an existing README
#' use_kpkg_badges()
#' }
use_kpkg_readme <- function(lifecycle = "experimental", overwrite = FALSE) {
  path <- usethis::proj_get()
  info <- repo_info(path)
  description <- desc::desc_get_field("Description", file = path, default = "")
  description <- gsub("\\s+", " ", trimws(description))
  install <- if (!is.null(info$github)) {
    sprintf('pak::pak("%s/%s")', info$github$owner, info$github$repo)
  } else if (!is.null(info$gitlab)) {
    sprintf(
      'pak::pak("git::https://%s/%s.git")', info$gitlab$host, info$gitlab$path
    )
  } else {
    sprintf('pak::pak("%s")', info$package)
  }
  usethis::use_build_ignore("^README\\.Rmd$", escape = FALSE)
  written <- copy_template(
    "project/README.Rmd", "README.Rmd",
    data = list(
      package = info$package,
      description = description,
      install = install
    ),
    overwrite = overwrite, header = FALSE
  )
  if (!is.na(written)) {
    use_kpkg_badges(lifecycle = lifecycle)
  }
  invisible(file.path(path, "README.Rmd"))
}

#' @rdname use_kpkg_readme
#' @export
use_kpkg_badges <- function(lifecycle = "experimental") {
  path <- usethis::proj_get()
  rmd <- file.path(path, "README.Rmd")
  md <- file.path(path, "README.md")
  if (!file.exists(rmd)) {
    if (!file.exists(md)) {
      stop(
        "No README.Rmd or README.md: use `use_kpkg_readme()`.",
        call. = FALSE
      )
    }
    usethis::use_build_ignore("^README\\.Rmd$", escape = FALSE)
    writeLines(
      enc2utf8(c(
        "---", "output: github_document", "---", "",
        "<!-- README.md is generated from README.Rmd. Please edit that file,",
        "then run devtools::build_readme(). -->", "",
        readLines(md, encoding = "UTF-8", warn = FALSE)
      )),
      rmd, useBytes = TRUE
    )
    message("Wrote README.Rmd, from README.md")
  }
  lines <- readLines(rmd, encoding = "UTF-8", warn = FALSE)
  lines <- set_badges(lines, readme_badges(repo_info(path), lifecycle))
  writeLines(enc2utf8(lines), rmd, useBytes = TRUE)
  message("Wrote the badges in README.Rmd")
  build_readme_md(path)
  invisible(rmd)
}

# Replaces the lines between the badges markers, or adds the block after the
# first title
set_badges <- function(lines, badges) {
  start <- grep("^<!-- badges: start -->$", lines)
  end <- grep("^<!-- badges: end -->$", lines)
  block <- c("<!-- badges: start -->", "", badges, "", "<!-- badges: end -->")
  if (length(start) == 1 && length(end) == 1 && start < end) {
    before <- lines[seq_len(start - 1)]
    after <- lines[-seq_len(end)]
    return(c(before, block, drop_badge_targets(after, badges)))
  }
  # after the first title, outside the YAML header and the code chunks
  in_code <- cumsum(grepl("^```", lines)) %% 2 == 1
  title <- which(grepl("^# ", lines) & !in_code)[1]
  if (is.na(title)) {
    title <- 0L
  }
  c(lines[seq_len(title)], "", block, lines[-seq_len(title)])
}

# Removes the targets of the badges (`[name]: url`, the URL possibly on the next
# line) that the badges of the block define again, e.g. those left by a
# previous README
drop_badge_targets <- function(lines, badges) {
  ids <- grep("^\\[.*\\]:$", badges, value = TRUE)
  ids <- sub("^\\[(.*)\\]:$", "\\1", ids)
  # also the names without the prefix of the host, and without `-badge`
  ids <- unique(sub("-badge$", "", sub("^(github|gitlab)-", "", c(ids, ids))))
  ids <- c(ids, paste0(ids, "-badge"))
  drop <- grepl(paste0("^\\[(", paste(ids, collapse = "|"), ")\\]:"), lines)
  # a target without URL: the URL is on the next line
  drop[which(drop & grepl(":$", lines)) + 1L] <- TRUE
  lines[!drop[seq_along(lines)]]
}

# Badges as markdown reference-style links: the URLs are on their own lines
readme_badges <- function(info, lifecycle = "experimental") {
  # the badges on consecutive lines make a single paragraph, then the targets
  # of the links
  badges <- character()
  targets <- character()
  add <- function(name, label, badge, link) {
    badges <<- c(badges, sprintf("[![%s][%s-badge]][%s]", label, name, name))
    targets <<- c(
      targets,
      sprintf("[%s-badge]:", name), badge,
      sprintf("[%s]:", name), link
    )
  }
  gh <- info$github
  if (!is.null(gh)) {
    repo <- paste0(gh$owner, "/", gh$repo)
    add(
      "github-check", "R-CMD-check",
      sprintf(
        "https://github.com/%s/actions/workflows/R-CMD-check.yaml/badge.svg",
        repo
      ),
      sprintf("https://github.com/%s/actions/workflows/R-CMD-check.yaml", repo)
    )
    add(
      "codecov", "Codecov test coverage",
      sprintf("https://codecov.io/gh/%s/graph/badge.svg", repo),
      sprintf("https://app.codecov.io/gh/%s", repo)
    )
  }
  gl <- info$gitlab
  if (!is.null(gl)) {
    base <- sprintf("https://%s/%s", gl$host, gl$path)
    add(
      "gitlab-pipeline", "Pipeline status",
      paste0(base, "/badges/main/pipeline.svg"),
      paste0(base, "/-/pipelines")
    )
    add(
      "gitlab-coverage", "Coverage",
      paste0(base, "/badges/main/coverage.svg"),
      paste0(base, "/-/graphs/main/charts")
    )
  }
  if (!is.null(lifecycle)) {
    add(
      "lifecycle", paste("Lifecycle:", lifecycle),
      sprintf(
        "https://img.shields.io/badge/lifecycle-%s-%s.svg",
        lifecycle, lifecycle_color(lifecycle)
      ),
      sprintf(
        "https://lifecycle.r-lib.org/articles/stages.html#%s", lifecycle
      )
    )
  }
  license <- license_badge(info$license)
  if (!is.null(license)) {
    add("license", paste("License:", license$name), license$badge, license$link)
  }
  c(badges, "", targets)
}

lifecycle_color <- function(lifecycle) {
  switch(
    lifecycle,
    experimental = "orange", stable = "brightgreen",
    superseded = "blue", deprecated = "red", "lightgrey"
  )
}

# Badge of the license field of DESCRIPTION, or NULL
license_badge <- function(license) {
  if (is.null(license) || is.na(license)) {
    return(NULL)
  }
  known <- list(
    list("^MIT", "MIT", "MIT", "https://opensource.org/licenses/MIT"),
    list(
      "^AGPL", "AGPL v3", "AGPL_v3", "https://www.gnu.org/licenses/agpl-3.0"
    ),
    list("^GPL", "GPL v3", "GPL_v3", "https://www.gnu.org/licenses/gpl-3.0"),
    list(
      "^Apache", "Apache 2.0", "Apache_2.0",
      "https://opensource.org/licenses/Apache-2.0"
    )
  )
  for (k in known) {
    if (grepl(k[[1]], license)) {
      return(list(
        name = k[[2]],
        badge = sprintf(
          "https://img.shields.io/badge/License-%s-blue.svg", k[[3]]
        ),
        link = k[[4]]
      ))
    }
  }
  NULL
}

# GitHub and GitLab repositories of the `URL` field of DESCRIPTION: a URL
# with an owner and a repository that is not a site (`*.github.io`,
# `*.pages*`, `*.gitlab.io`) is a GitLab repository when it is not on
# github.com.
repo_info <- function(path) {
  desc_file <- file.path(path, "DESCRIPTION")
  urls <- desc::desc_get_field("URL", file = desc_file, default = "")
  urls <- trimws(strsplit(gsub("\\s+", " ", urls), "[, ]+")[[1]])
  info <- list(
    package = desc::desc_get_field("Package", file = desc_file),
    license = desc::desc_get_field("License", file = desc_file, default = NA)
  )
  pattern <- "^https://([^/]+)/([^/]+(?:/[^/]+)*?)/?$"
  for (url in grep(pattern, urls, value = TRUE, perl = TRUE)) {
    info <- add_repo_url(info, url, pattern)
  }
  info
}

# Adds the GitHub or GitLab repository of `url` to `info`, if it has none yet
add_repo_url <- function(info, url, pattern) {
  host <- sub(pattern, "\\1", url, perl = TRUE)
  repo <- sub(pattern, "\\2", url, perl = TRUE)
  if (grepl("(github|gitlab)\\.io$|\\.pages", host)) {
    return(info)
  }
  if (host == "github.com") {
    parts <- strsplit(repo, "/")[[1]]
    if (length(parts) == 2 && is.null(info$github)) {
      info$github <- list(owner = parts[1], repo = parts[2])
    }
  } else if (grepl("/", repo) && is.null(info$gitlab)) {
    info$gitlab <- list(host = host, path = repo)
  }
  info
}

# README.md from README.Rmd
build_readme_md <- function(path) {
  rmd <- file.path(path, "README.Rmd")
  md <- file.path(path, "README.md")
  has_code <- any(grepl("^```\\{r", readLines(rmd, warn = FALSE)))
  can_render <- requireNamespace("rmarkdown", quietly = TRUE) &&
    rmarkdown::pandoc_available()
  if (has_code && requireNamespace("devtools", quietly = TRUE)) {
    # the code of the README uses the package: it is installed first
    devtools::build_readme(path, quiet = TRUE)
    message("Wrote README.md (devtools::build_readme())")
  } else if (can_render) {
    rmarkdown::render(
      rmd,
      output_format = rmarkdown::github_document(html_preview = FALSE),
      output_file = "README.md", quiet = TRUE
    )
    unlink(file.path(path, "README.html"))
    message("Wrote README.md")
  } else {
    lines <- readLines(rmd, encoding = "UTF-8", warn = FALSE)
    yaml <- which(lines == "---")
    if (length(yaml) >= 2 && yaml[1] == 1) {
      lines <- lines[-seq_len(yaml[2])]
      lines <- lines[cumsum(nzchar(lines)) > 0]
    }
    writeLines(enc2utf8(lines), md, useBytes = TRUE)
    message("Wrote README.md (Pandoc not available: text of README.Rmd)")
  }
}
