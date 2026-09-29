# Changelog

## kpkg.r 0.1.0

- Première version.
- [`create_pkg()`](https://kbosirany.github.io/kpkg.r/reference/create_pkg.md)
  crée un package avec l’auteur de
  [`kpkg_author()`](https://kbosirany.github.io/kpkg.r/reference/kpkg_author.md),
  la licence MIT, roxygen2, testthat (3e édition), `README.md`,
  `NEWS.md`, un `.lintr` et un `_pkgdown.yml`, et ajoute l’intégration
  continue GitHub et/ou GitLab.
- [`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md)
  et
  [`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md)
  ajoutent des templates d’intégration continue versionnés :
  `R CMD check` et site pkgdown (branche `main` à la racine, branche
  `dev` dans `/dev`).
- [`use_kpkg_pkgdown()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_pkgdown.md),
  [`use_kpkg_lintr()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_lintr.md)
  et
  [`kpkg_templates()`](https://kbosirany.github.io/kpkg.r/reference/kpkg_templates.md).
