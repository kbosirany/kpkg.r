test_that("repo_info() finds the GitHub and GitLab repositories", {
  path <- withr::local_tempdir()
  writeLines(
    c(
      "Package: x", "License: MIT + file LICENSE",
      paste0(
        "URL: https://github.com/Owner/x, https://owner.github.io/x/,",
        " https://forge.example.fr/group/sub/x,",
        " https://x-bc523c.pages-forge.example.fr"
      )
    ),
    file.path(path, "DESCRIPTION")
  )
  info <- repo_info(path)
  expect_equal(info$github, list(owner = "Owner", repo = "x"))
  expect_equal(
    info$gitlab, list(host = "forge.example.fr", path = "group/sub/x")
  )

  writeLines("Package: x", file.path(path, "DESCRIPTION"))
  info <- repo_info(path)
  expect_null(info$github)
  expect_null(info$gitlab)
})

test_that("readme_badges() depends on the repositories", {
  github <- list(
    package = "x", license = "MIT + file LICENSE",
    github = list(owner = "o", repo = "x")
  )
  badges <- readme_badges(github)
  expect_true(any(grepl("^\\[!\\[R-CMD-check\\]", badges)))
  expect_true(any(grepl("codecov.io/gh/o/x/graph/badge.svg", badges)))
  expect_true(any(grepl("License-MIT", badges)))
  expect_false(any(grepl("pipeline.svg", badges)))

  gitlab <- list(
    package = "x", license = "AGPL (>= 3)",
    gitlab = list(host = "forge.example.fr", path = "g/x")
  )
  badges <- readme_badges(gitlab, lifecycle = "stable")
  expect_true(any(grepl("forge.example.fr/g/x/badges/main/pipeline.svg", badges,
                        fixed = TRUE)))
  expect_true(any(grepl("badges/main/coverage.svg", badges, fixed = TRUE)))
  expect_true(any(grepl("lifecycle-stable-brightgreen", badges)))
  expect_true(any(grepl("AGPL_v3", badges)))
  expect_false(any(grepl("codecov", badges)))

  expect_false(any(grepl("lifecycle", readme_badges(gitlab, lifecycle = NULL))))
})

test_that("set_badges() replaces the block or adds it after the title", {
  badges <- c("[![A][a-badge]][a]")
  lines <- c("# x", "", "<!-- badges: start -->", "old", "<!-- badges: end -->",
             "text")
  out <- set_badges(lines, badges)
  expect_false("old" %in% out)
  expect_equal(sum(out == "<!-- badges: start -->"), 1)
  expect_equal(out[length(out)], "text")

  # no block: after the first title, not the one of a code chunk
  lines <- c("---", "output: github_document", "---", "", "# x", "text",
             "```r", "# comment", "```")
  out <- set_badges(lines, badges)
  expect_equal(which(out == "<!-- badges: start -->"), 7)
  expect_equal(out[5], "# x")

  # idempotent
  expect_equal(set_badges(out, badges), out)
})

test_that("use_kpkg_readme() writes the README with the badges", {
  path <- local_pkg(
    fields = list(
      URL = "https://github.com/KBosirany/testpkg",
      Description = "Does something\n    useful."
    )
  )
  suppressMessages(use_kpkg_readme())
  rmd <- read_file(file.path(path, "README.Rmd"))
  expect_true("# testpkg" %in% rmd)
  expect_true("Does something useful." %in% rmd)
  expect_true('pak::pak("KBosirany/testpkg")' %in% rmd)
  expect_true(any(grepl("codecov.io/gh/KBosirany/testpkg", rmd, fixed = TRUE)))
  expect_false(any(grepl("{{", rmd, fixed = TRUE)))
  expect_true(file.exists(file.path(path, "README.md")))
  expect_true("^README\\.Rmd$" %in% read_file(file.path(path, ".Rbuildignore")))
})

test_that("use_kpkg_badges() converts a README.md and is idempotent", {
  path <- local_pkg(
    fields = list(URL = "https://forge.example.fr/g/testpkg")
  )
  writeLines(c("# testpkg", "", "Some text."), file.path(path, "README.md"))
  suppressMessages(use_kpkg_badges())
  rmd <- read_file(file.path(path, "README.Rmd"))
  expect_equal(rmd[1], "---")
  expect_true("Some text." %in% rmd)
  expect_true(any(grepl("badges/main/coverage.svg", rmd, fixed = TRUE)))

  suppressMessages(use_kpkg_badges())
  expect_equal(read_file(file.path(path, "README.Rmd")), rmd)
})

test_that("set_badges() drops the old targets of the badges", {
  badges <- c("[![A][github-check-badge]][github-check]", "",
              "[github-check-badge]:", "https://a", "[github-check]:", "b")
  lines <- c("# x", "<!-- badges: start -->", "<!-- badges: end -->", "text",
             "[check-badge]: https://old", "[check]: https://old2",
             "[other]: https://keep")
  out <- set_badges(lines, badges)
  expect_false(any(grepl("old", out)))
  expect_true("[other]: https://keep" %in% out)
  expect_true("text" %in% out)
})
