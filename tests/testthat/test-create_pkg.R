test_that("create_pkg() creates a package with the conventions", {
  withr::local_options(usethis.quiet = TRUE, kpkg.r.author = NULL)
  dir <- withr::local_tempdir()
  path <- quiet(create_pkg(
    file.path(dir, "monpkg"),
    title = "Do Something Useful",
    git = FALSE, rstudio = FALSE, open = FALSE
  ))

  expect_true(dir.exists(path))
  desc <- read.dcf(file.path(path, "DESCRIPTION"))
  expect_equal(unname(desc[, "Package"]), "monpkg")
  expect_equal(unname(desc[, "Title"]), "Do Something Useful")
  expect_equal(unname(desc[, "License"]), "AGPL (>= 3)")
  expect_match(desc[, "URL"], "https://github.com/kbosirany/monpkg")
  expect_match(desc[, "URL"], "https://kbosirany.github.io/monpkg/")
  expect_match(desc[, "Authors@R"], "0009-0009-2784-3108")
  expect_match(desc[, "Config/testthat/edition"], "3")

  license <- read_file(file.path(path, "LICENSE.md"))
  expect_true("GNU Affero General Public License" %in% license)
  expect_false(file.exists(file.path(path, "LICENSE")))

  files <- c(
    "README.md", "NEWS.md", ".lintr", "_pkgdown.yml", "tests/testthat.R",
    ".github/workflows/R-CMD-check.yaml", ".github/workflows/pkgdown.yaml",
    ".gitlab-ci.yml"
  )
  expect_true(all(file.exists(file.path(path, files))))
  expect_true(
    "url: https://kbosirany.github.io/monpkg/" %in%
      read_file(file.path(path, "_pkgdown.yml"))
  )
  expect_true(all(nchar(read_file(file.path(path, "DESCRIPTION"))) <= 80))
})

test_that("create_pkg() without GitHub nor CI", {
  withr::local_options(usethis.quiet = TRUE)
  dir <- withr::local_tempdir()
  path <- quiet(create_pkg(
    file.path(dir, "monpkg"),
    github_owner = NULL, ci = character(),
    git = FALSE, rstudio = FALSE, open = FALSE
  ))
  desc <- read.dcf(file.path(path, "DESCRIPTION"))
  expect_false("URL" %in% colnames(desc))
  expect_false(dir.exists(file.path(path, ".github")))
  expect_false(file.exists(file.path(path, ".gitlab-ci.yml")))
})

test_that("create_pkg() initialises a Git repository", {
  skip_if_not_installed("gert")
  withr::local_options(usethis.quiet = TRUE)
  dir <- withr::local_tempdir()
  path <- quiet(create_pkg(
    file.path(dir, "sub", "monpkg"),
    rstudio = FALSE, open = FALSE
  ))
  expect_true(dir.exists(file.path(path, ".git")))
})
