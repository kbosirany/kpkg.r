test_that("all templates exist and have lines of 80 characters or less", {
  templates <- kpkg_templates()
  expect_named(templates, c("template", "target", "fun"))
  for (template in templates$template) {
    src <- system.file("templates", template, package = "kpkg.r")
    expect_true(nzchar(src), label = template)
    expect_true(all(nchar(read_file(src)) <= 80), label = template)
  }
  expect_true(all(
    vapply(templates$fun, exists, logical(1), envir = asNamespace("kpkg.r"))
  ))
})

test_that("use_kpkg_github() copies the workflows with a version header", {
  path <- local_pkg()
  msgs <- capture_messages(files <- use_kpkg_github())
  expect_match(msgs, "R-CMD-check.yaml", all = FALSE)
  expect_length(files, 3)
  check <- read_file(file.path(path, ".github/workflows/R-CMD-check.yaml"))
  expect_match(
    check[1],
    paste0("^# Template kpkg.r ", packageVersion("kpkg.r"))
  )
  expect_true(file.exists(file.path(path, ".github/workflows/pkgdown.yaml")))
  expect_true(
    file.exists(file.path(path, ".github/workflows/test-coverage.yaml"))
  )
  expect_true("^\\.github$" %in% read_file(file.path(path, ".Rbuildignore")))
})

test_that("the site scripts are added by the CI and pkgdown functions", {
  path <- local_pkg()
  scripts <- file.path(path, "dev", c("build_site.R", "render_reports.R"))

  suppressMessages(use_kpkg_gitlab())
  expect_true(all(file.exists(scripts)))
  expect_match(read_file(scripts[1])[1], "^# Template kpkg.r")
  expect_true("^dev$" %in% read_file(file.path(path, ".Rbuildignore")))

  # a script that exists is kept
  writeLines("custom", scripts[1])
  suppressMessages(use_kpkg_github())
  expect_equal(read_file(scripts[1]), "custom")

  suppressMessages(use_kpkg_site_scripts(overwrite = TRUE))
  expect_match(read_file(scripts[1])[1], "^# Template kpkg.r")
})

test_that("the CI runs dev/build_site.R", {
  for (template in c("github/pkgdown.yaml", "gitlab/gitlab-ci.yml")) {
    src <- system.file("templates", template, package = "kpkg.r")
    expect_true(any(grepl("dev/build_site.R", read_file(src), fixed = TRUE)))
  }
})

test_that("existing files are kept unless overwrite = TRUE", {
  path <- local_pkg()
  target <- file.path(path, ".gitlab-ci.yml")
  writeLines("custom", target)
  expect_message(use_kpkg_gitlab(), "Kept existing")
  expect_equal(read_file(target), "custom")

  suppressMessages(use_kpkg_gitlab(overwrite = TRUE))
  expect_match(read_file(target)[1], "^# Template kpkg.r")
  expect_true(
    "^\\.gitlab-ci\\.yml$" %in% read_file(file.path(path, ".Rbuildignore"))
  )
})

test_that("use_kpkg_pkgdown() derives the site URL from DESCRIPTION", {
  path <- local_pkg(
    fields = list(URL = "https://github.com/KBosirany/testpkg")
  )
  suppressMessages(use_kpkg_pkgdown(lang = "en"))
  config <- read_file(file.path(path, "_pkgdown.yml"))
  expect_true("url: https://kbosirany.github.io/testpkg/" %in% config)
  expect_true("lang: en" %in% config)
})

test_that("use_kpkg_pkgdown() drops the URL when there is none", {
  path <- local_pkg()
  suppressMessages(use_kpkg_pkgdown())
  config <- read_file(file.path(path, "_pkgdown.yml"))
  expect_false(any(grepl("^url:", config)))
  expect_true("lang: fr" %in% config)
  expect_false(any(grepl("{{", config, fixed = TRUE)))
})

test_that("use_kpkg_lintr() writes a .lintr without header", {
  path <- local_pkg()
  suppressMessages(use_kpkg_lintr())
  lintr <- read_file(file.path(path, ".lintr"))
  expect_match(lintr[1], "line_length_linter(80L)", fixed = TRUE)
})

test_that("github_pages_url() handles missing URLs", {
  path <- withr::local_tempdir()
  expect_null(github_pages_url(path))
  writeLines("Package: x", file.path(path, "DESCRIPTION"))
  expect_null(github_pages_url(path))
  writeLines(
    c("Package: x", "URL: https://gitlab.com/a/x, https://github.com/a/x/"),
    file.path(path, "DESCRIPTION")
  )
  expect_equal(github_pages_url(path), "https://a.github.io/x/")
})

test_that("report_packages() finds the packages used by the reports", {
  env <- new.env()
  sys.source(
    system.file("templates/project/render_reports.R", package = "kpkg.r"),
    envir = env
  )
  dir <- withr::local_tempdir()
  withr::local_dir(dir)
  writeLines(
    c("Package: x", "Imports: pkgnotinstalledA", "Suggests: pkgnotinstalledB"),
    "DESCRIPTION"
  )
  dir.create("reports/book", recursive = TRUE)
  writeLines(
    c(
      "A text with prose::notcode and library(proseonly).", "",
      "```{r}", "library(pkgnotinstalledC)", "pkgnotinstalledD::f()",
      "# library(pkgnotinstalledcomment)", "library(pkgnotinstalledA)", "```",
      "", "```{ojs}", "library(pkgnotinstalledojs)", "```", "",
      "```{r, echo = FALSE}",
      "requireNamespace(\"pkgnotinstalledE\", quietly = TRUE)", "```"
    ),
    "reports/book/index.qmd"
  )
  writeLines("pkgnotinstalledF::g()", "reports/book/helper.R")
  expect_equal(
    env$report_packages("reports"),
    paste0("pkgnotinstalled", c("C", "D", "E", "F"))
  )

  # outside the CI, the missing packages are only reported
  withr::local_envvar(CI = "false")
  expect_warning(env$install_report_packages("reports"), "not installed")
})
