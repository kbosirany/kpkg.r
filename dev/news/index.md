# Changelog

## kpkg.r (development version)

## kpkg.r 0.2.0

- `dev/render_reports.R` installe, en CI, les paquets utilisés par le
  code des rapports ([`library()`](https://rdrr.io/r/base/library.html),
  [`require()`](https://rdrr.io/r/base/library.html), `pkg::`) qui ne
  sont pas installés ; hors CI, il avertit seulement. Plus besoin de les
  déclarer dans `Suggests` pour que le job `pages` rende les rapports.

- [`use_kpkg_readme()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_readme.md)
  ajoute un `README.Rmd` (et `README.md`) avec les badges principaux, et
  [`use_kpkg_badges()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_readme.md)
  met à jour le bloc de badges d’un README existant : pipeline ou
  `R-CMD-check`, couverture de tests, cycle de vie et licence, selon les
  dépôts GitHub et GitLab de l’URL de `DESCRIPTION`.
  [`create_pkg()`](https://kbosirany.github.io/kpkg.r/dev/reference/create_pkg.md)
  ajoute le README.

- Couverture de tests avec covr : workflow GitHub `test-coverage`
  (Codecov) et job GitLab `coverage` (badge `coverage.svg` de GitLab).

- [`use_kpkg_site_scripts()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_site_scripts.md)
  ajoute `dev/build_site.R` et `dev/render_reports.R` : le site pkgdown
  est construit, puis les livres Quarto de `reports/` sont rendus dans
  `<site>/reports/<livre>/` (chemin absolu) avec l’entrée `Reports [fr]`
  dans la navbar. Cela corrige les liens vers les rapports qui donnaient
  une erreur 404 sur le site du package.

- Le workflow GitHub `pkgdown` et le job GitLab `pages` lancent
  `dev/build_site.R` (et installent le CLI Quarto et le package quarto
  quand `reports/` contient un livre).
  [`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_github.md),
  [`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_gitlab.md)
  et
  [`use_kpkg_pkgdown()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_pkgdown.md)
  ajoutent les scripts.

- [`create_pkg()`](https://kbosirany.github.io/kpkg.r/dev/reference/create_pkg.md)
  utilise maintenant la licence AGPL (\>= 3) au lieu de MIT :
  `License: AGPL (>= 3)` et `LICENSE.md` (plus de fichier `LICENSE`).

- Nouvelle fonction
  [`use_kpkg_license()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_license.md)
  : applique la licence AGPL (\>= 3) à un package existant, par exemple
  créé avec une version antérieure de kpkg.r (licence MIT). Elle ne
  remplace que les licences posées par kpkg.r (`MIT + file LICENSE` ou
  le texte provisoire de usethis) sauf avec `overwrite = TRUE`.

- kpkg.r passe lui-même sous licence AGPL (\>= 3).

- La vignette `workflow` décrit les badges (GitHub et GitLab), la
  couverture de tests et le réglage manuel de Codecov.

## kpkg.r 0.1.0

- Première version.
- [`create_pkg()`](https://kbosirany.github.io/kpkg.r/dev/reference/create_pkg.md)
  crée un package avec l’auteur de
  [`kpkg_author()`](https://kbosirany.github.io/kpkg.r/dev/reference/kpkg_author.md),
  la licence MIT, roxygen2, testthat (3e édition), `README.md`,
  `NEWS.md`, un `.lintr` et un `_pkgdown.yml`, et ajoute l’intégration
  continue GitHub et/ou GitLab.
- [`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_github.md)
  et
  [`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_gitlab.md)
  ajoutent des templates d’intégration continue versionnés :
  `R CMD check` et site pkgdown (branche `main` à la racine, branche
  `dev` dans `/dev`).
- [`use_kpkg_pkgdown()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_pkgdown.md),
  [`use_kpkg_lintr()`](https://kbosirany.github.io/kpkg.r/dev/reference/use_kpkg_lintr.md)
  et
  [`kpkg_templates()`](https://kbosirany.github.io/kpkg.r/dev/reference/kpkg_templates.md).
