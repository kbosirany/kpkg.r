# kpkg.r 0.1.0.9000

* `create_pkg()` utilise maintenant la licence AGPL (>= 3) au lieu de MIT :
  `License: AGPL (>= 3)` et `LICENSE.md` (plus de fichier `LICENSE`).
* Nouvelle fonction `use_kpkg_license()` : applique la licence AGPL (>= 3) à un
  package existant, par exemple créé avec une version antérieure de kpkg.r
  (licence MIT). Elle ne remplace que les licences posées par kpkg.r
  (`MIT + file LICENSE` ou le texte provisoire de usethis) sauf avec
  `overwrite = TRUE`.
* kpkg.r passe lui-même sous licence AGPL (>= 3).

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
