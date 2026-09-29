# Creates a bare package in a temporary folder and makes it the active
# usethis project until the end of the calling test
local_pkg <- function(name = "testpkg", fields = list(),
                      env = parent.frame()) {
  dir <- withr::local_tempdir(.local_envir = env)
  path <- file.path(dir, name)
  withr::local_options(usethis.quiet = TRUE, .local_envir = env)
  usethis::create_package(
    path,
    fields = fields, rstudio = FALSE, open = FALSE
  )
  usethis::local_project(path, quiet = TRUE, .local_envir = env)
  path
}

read_file <- function(path) {
  readLines(path, encoding = "UTF-8", warn = FALSE)
}

# usethis looks up CRAN versions, which warns when offline
quiet <- function(expr) {
  suppressWarnings(suppressMessages(expr))
}
