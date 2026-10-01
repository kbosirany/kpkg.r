# kpkg.r (development version)

* `dev/render_reports.R` installe, en CI, les paquets utilisés par le code des
  rapports (`library()`, `require()`, `pkg::`) qui ne sont pas installés ;
  hors CI, il avertit seulement. Plus besoin de les déclarer dans
  `Suggests` pour que le job `pages` rende les rapports.

* `use_kpkg_readme()` ajoute un `README.Rmd` (et `README.md`) avec les badges
  principaux, et `use_kpkg_badges()` met à jour le bloc de badges d'un README
  existant : pipeline ou `R-CMD-check`, couverture de tests, cycle de vie et
  licence, selon les dépôts GitHub et GitLab de l'URL de `DESCRIPTION`.
  `create_pkg()` ajoute le README.
* Couverture de tests avec covr : workflow GitHub `test-coverage` (Codecov) et
  job GitLab `coverage` (badge `coverage.svg` de GitLab).

* `use_kpkg_site_scripts()` ajoute `dev/build_site.R` et
  `dev/render_reports.R` : le site pkgdown est construit, puis les livres
  Quarto de `reports/` sont rendus dans `<site>/reports/<livre>/` (chemin
  absolu) avec l'entrée `Reports [fr]` dans la navbar. Cela corrige les liens
  vers les rapports qui donnaient une erreur 404 sur le site du package.
* Le workflow GitHub `pkgdown` et le job GitLab `pages` lancent
  `dev/build_site.R` (et installent le CLI Quarto et le package quarto quand
  `reports/` contient un livre). `use_kpkg_github()`, `use_kpkg_gitlab()` et
  `use_kpkg_pkgdown()` ajoutent les scripts.

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
