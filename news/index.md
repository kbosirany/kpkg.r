# Changelog

## kpkg.r (development version)

- [`use_kpkg_site_scripts()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_site_scripts.md)
  ajoute `dev/build_site.R` et `dev/render_reports.R` : le site pkgdown
  est construit, puis les livres Quarto de `reports/` sont rendus dans
  `<site>/reports/<livre>/` (chemin absolu) avec l’entrée `Reports [fr]`
  dans la navbar. Cela corrige les liens vers les rapports qui donnaient
  une erreur 404 sur le site du package.
- Le workflow GitHub `pkgdown` et le job GitLab `pages` lancent
  `dev/build_site.R` (et installent le CLI Quarto et le package quarto
  quand `reports/` contient un livre).
  [`use_kpkg_github()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_github.md),
  [`use_kpkg_gitlab()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_gitlab.md)
  et
  [`use_kpkg_pkgdown()`](https://kbosirany.github.io/kpkg.r/reference/use_kpkg_pkgdown.md)
  ajoutent les scripts.

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
