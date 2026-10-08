# kpkg.r (development version)

* Template `gitlab/gitlab-ci.yml` : `pak` est installé depuis les binaires de
  r-lib (`https://r-lib.github.io/p/pak/stable/...`) au lieu de
  `install.packages("pak")`, avec repli sur CRAN. Avec R-devel, qui n'a pas de
  binaires sur CRAN, `pak` était compilé depuis les sources (environ 3 minutes
  par job `check`).

* Template `gitlab/gitlab-ci.yml` : le job `check` ne teste plus que la version
  publiée de R sur toutes les branches. R-devel est dans un job `check-devel`
  (lent : sans binaires, les paquets sont compilés), qui ne tourne que sur
  `dev` et `main` et ne bloque pas le pipeline (`allow_failure`). Le job
  `coverage` est inchangé.

* `dev/render_reports.R` : les rapports forment un seul menu `Reports` dans la
  barre de navigation, avec un en-tête par langue (`English`, `Français`,
  d'après le suffixe `-en`/`-fr` du dossier) quand il y a plusieurs langues,
  sans en-tête sinon. Remplace les menus `reports_fr` et `reports_en`.

# kpkg.r 0.2.0

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

* `create_pkg()` utilise maintenant la licence AGPL (>= 3) au lieu de MIT :
  `License: AGPL (>= 3)` et `LICENSE.md` (plus de fichier `LICENSE`).
* Nouvelle fonction `use_kpkg_license()` : applique la licence AGPL (>= 3) à un
  package existant, par exemple créé avec une version antérieure de kpkg.r
  (licence MIT). Elle ne remplace que les licences posées par kpkg.r
  (`MIT + file LICENSE` ou le texte provisoire de usethis) sauf avec
  `overwrite = TRUE`.
* kpkg.r passe lui-même sous licence AGPL (>= 3).
* La vignette `workflow` décrit les badges (GitHub et GitLab), la couverture de
  tests et le réglage manuel de Codecov.

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
