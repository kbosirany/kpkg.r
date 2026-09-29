# kpkg.r 0.1.0

* Première version.
* `create_pkg()` crée un package avec l'auteur de `kpkg_author()`, la
  licence MIT, roxygen2, testthat (3e édition), `README.md`, `NEWS.md`,
  un `.lintr` et un `_pkgdown.yml`, et ajoute l'intégration continue GitHub
  et/ou GitLab.
* `use_kpkg_github()` et `use_kpkg_gitlab()` ajoutent des templates
  d'intégration continue versionnés : `R CMD check` et site pkgdown (branche
  `main` à la racine, branche `dev` dans `/dev`).
* `use_kpkg_pkgdown()`, `use_kpkg_lintr()` et `kpkg_templates()`.
