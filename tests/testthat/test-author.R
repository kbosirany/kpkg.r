test_that("kpkg_author() returns the default author", {
  withr::local_options(kpkg.r.author = NULL)
  author <- kpkg_author()
  expect_s3_class(author, "person")
  expect_equal(author$family, "Orlando")
  expect_equal(author_name(author), "Kevin Bosirany Orlando")
})

test_that("the option kpkg.r.author overrides the default author", {
  jane <- person("Jane", "Doe", role = c("aut", "cre"))
  withr::local_options(kpkg.r.author = jane)
  expect_equal(kpkg_author(), jane)

  withr::local_options(kpkg.r.author = "Jane Doe")
  expect_error(kpkg_author(), "must be a `person()`", fixed = TRUE)
})

test_that("author_name() picks the maintainer", {
  authors <- c(
    person("Jane", "Doe", role = "aut"),
    person("John", "Smith", role = c("aut", "cre"))
  )
  expect_equal(author_name(authors), "John Smith")
  expect_equal(author_name(person("Jane", "Doe")), "Jane Doe")
})

test_that("authors_field() parses back to the same persons", {
  authors <- c(person("Jane", "Doe", role = "ctb"), default_author())
  field <- authors_field(authors)
  expect_equal(eval(parse(text = field)), authors)
  expect_true(all(nchar(strsplit(field, "\n")[[1]]) <= 80))
})
