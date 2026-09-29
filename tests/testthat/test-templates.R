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
  expect_length(files, 2)
  check <- read_file(file.path(path, ".github/workflows/R-CMD-check.yaml"))
  expect_match(
    check[1],
    paste0("^# Template kpkg.r ", packageVersion("kpkg.r"))
  )
  expect_true(file.exists(file.path(path, ".github/workflows/pkgdown.yaml")))
  expect_true("^\\.github$" %in% read_file(file.path(path, ".Rbuildignore")))
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
