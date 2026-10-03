license_field <- function(path) {
  unname(read.dcf(file.path(path, "DESCRIPTION"))[, "License"])
}

test_that("use_kpkg_license() replaces the usethis placeholder", {
  path <- local_pkg()
  expect_match(license_field(path), "use_mit_license", fixed = TRUE)
  res <- use_kpkg_license()
  # normalised: on macOS the temporary folder is a symbolic link
  expect_equal(normalizePath(res), normalizePath(file.path(path, "LICENSE.md")))
  expect_equal(license_field(path), "AGPL (>= 3)")
  expect_true(
    "GNU Affero General Public License" %in%
      read_file(file.path(path, "LICENSE.md"))
  )
  expect_false(file.exists(file.path(path, "LICENSE")))
  expect_true("^LICENSE\\.md$" %in% read_file(file.path(path, ".Rbuildignore")))
})

test_that("use_kpkg_license() updates a package with the former MIT default", {
  path <- local_pkg()
  usethis::use_mit_license(copyright_holder = "Kevin Bosirany Orlando")
  expect_equal(license_field(path), "MIT + file LICENSE")
  expect_true(file.exists(file.path(path, "LICENSE")))
  expect_true(
    "# MIT License" %in% read_file(file.path(path, "LICENSE.md"))
  )

  use_kpkg_license()
  expect_equal(license_field(path), "AGPL (>= 3)")
  expect_false(file.exists(file.path(path, "LICENSE")))
  license_md <- read_file(file.path(path, "LICENSE.md"))
  expect_true("GNU Affero General Public License" %in% license_md)
  expect_false("# MIT License" %in% license_md)
  # The rest of DESCRIPTION is untouched
  expect_equal(
    unname(read.dcf(file.path(path, "DESCRIPTION"))[, "Package"]), "testpkg"
  )
})

test_that("use_kpkg_license() does nothing if the AGPL is already set", {
  path <- local_pkg()
  use_kpkg_license()
  before <- read_file(file.path(path, "LICENSE.md"))
  expect_message(res <- use_kpkg_license(), "already")
  expect_null(res)
  expect_equal(read_file(file.path(path, "LICENSE.md")), before)
})

test_that("other licenses are replaced only with overwrite = TRUE", {
  path <- local_pkg()
  usethis::use_gpl3_license()
  expect_error(use_kpkg_license(), "overwrite = TRUE")
  expect_match(license_field(path), "GPL")
  expect_false(license_field(path) == "AGPL (>= 3)")

  use_kpkg_license(overwrite = TRUE)
  expect_equal(license_field(path), "AGPL (>= 3)")
  expect_true(
    "GNU Affero General Public License" %in%
      read_file(file.path(path, "LICENSE.md"))
  )
})
