#' Set the kpkg.r license on a package
#'
#' Applies the default kpkg.r license, the AGPL (>= 3), to the active
#' package: `License: AGPL (>= 3)` in `DESCRIPTION` and the license text in
#' `LICENSE.md`. [create_pkg()] calls it for new packages; call it in a
#' package created with an earlier version of kpkg.r (MIT license) to update
#' it.
#'
#' The `LICENSE` file that goes with `MIT + file LICENSE` (year and copyright
#' holder only) is removed, as the AGPL needs none.
#'
#' Only licenses that kpkg.r itself can have set are replaced: the
#' placeholder written by [usethis::create_package()] and
#' `MIT + file LICENSE`, the former default of kpkg.r. Any other license is
#' left alone unless `overwrite = TRUE`, as changing the license of a package
#' is a decision of its copyright holders. Mentions of the old license in
#' other files (README, vignettes, headers) are not changed.
#'
#' @param overwrite Whether to replace a license that kpkg.r did not set.
#'
#' @return The path of `LICENSE.md`, invisibly, or `NULL` if the package
#'   already has the AGPL (>= 3) license.
#' @seealso [use_kpkg_github()] and the other `use_kpkg_*()` functions to
#'   update the other files created by kpkg.r.
#' @export
#' @examples
#' \dontrun{
#' # In a package created with an earlier version of kpkg.r
#' use_kpkg_license()
#'
#' # Replace any other license (e.g. GPL-3), knowing what it implies
#' use_kpkg_license(overwrite = TRUE)
#' }
use_kpkg_license <- function(overwrite = FALSE) {
  path <- usethis::proj_get()
  current <- desc::desc_get_field(
    "License",
    default = NA_character_, file = path
  )
  if (identical(current, kpkg_license)) {
    message("The license is already ", kpkg_license, ".")
    return(invisible(NULL))
  }
  if (!overwrite && !is_replaceable_license(current)) {
    stop(
      "The license of the package is `", current, "`, not one set by ",
      "kpkg.r. Use `overwrite = TRUE` to replace it.",
      call. = FALSE
    )
  }

  # The license file of "<license> + file LICENSE" and the previous
  # LICENSE.md (which usethis would keep) belong to the old license
  if (!is.na(current) && grepl("file LICENSE", current, fixed = TRUE)) {
    unlink(file.path(path, "LICENSE"))
  }
  unlink(file.path(path, "LICENSE.md"))
  usethis::use_agpl_license(version = 3)
  invisible(file.path(path, "LICENSE.md"))
}

kpkg_license <- "AGPL (>= 3)"

# Licenses that kpkg.r sets itself: the placeholder of usethis::create_package()
# and the former default
is_replaceable_license <- function(license) {
  is.na(license) ||
    startsWith(license, "`use_") ||
    identical(license, "MIT + file LICENSE")
}
