#' Default package author
#'
#' The author written in the `Authors@R` field of the packages created with
#' [create_pkg()]. Another author can be used by setting the option
#' `kpkg.r.author` to a [utils::person()], e.g. in your `.Rprofile`.
#'
#' @return A [utils::person()] object.
#' @export
#' @examples
#' kpkg_author()
#'
#' # Use another author for the current session
#' old <- options(
#'   kpkg.r.author = person("Jane", "Doe", role = c("aut", "cre"))
#' )
#' kpkg_author()
#' options(old)
kpkg_author <- function() {
  author <- getOption("kpkg.r.author")
  if (is.null(author)) {
    return(default_author())
  }
  if (!inherits(author, "person")) {
    stop("The option `kpkg.r.author` must be a `person()`.", call. = FALSE)
  }
  author
}

default_author <- function() {
  utils::person(
    given = c("Kevin", "Bosirany"),
    family = "Orlando",
    email = "kevinbosirany@gmail.com",
    role = c("aut", "cre"),
    comment = c(ORCID = "0009-0009-2784-3108")
  )
}

# `Authors@R` field, one argument per line to stay under 80 characters
authors_field <- function(author) {
  persons <- vapply(seq_along(author), function(i) {
    p <- author[[i]]
    args <- c(
      given = deparse_arg(p$given),
      family = deparse_arg(p$family),
      email = deparse_arg(p$email),
      role = deparse_arg(p$role),
      comment = deparse_arg(p$comment)
    )
    args <- args[!is.na(args)]
    paste0(
      "    person(\n",
      paste0("      ", names(args), " = ", args, collapse = ",\n"),
      "\n    )"
    )
  }, character(1))
  paste0("c(\n", paste(persons, collapse = ",\n"), "\n  )")
}

deparse_arg <- function(x) {
  if (is.null(x) || length(x) == 0) {
    return(NA_character_)
  }
  paste(deparse(unclass(x), width.cutoff = 60L), collapse = " ")
}
