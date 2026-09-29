# kpkg.r

Site : <https://kbosirany.github.io/kpkg.r/> (version en développement :
[/dev](https://kbosirany.github.io/kpkg.r/dev/))

Un compagnon personnel de [usethis](https://usethis.r-lib.org) : créer
des packages R avec mes conventions (auteur, licence MIT, roxygen2,
testthat, lignes de 80 caractères) et ajouter des templates
d’intégration continue versionnés, pour GitHub Actions comme pour GitLab
CI.

## Installation

``` r

# install.packages("pak")
pak::pak("kbosirany/kpkg.r")
```

## Utilisation

``` r

library(kpkg.r)

# Nouveau package : DESCRIPTION, licence MIT, tests, README, NEWS,
# .lintr, _pkgdown.yml, workflows GitHub et .gitlab-ci.yml
create_pkg("~/projets/monpkg", title = "Do Something Useful")

# Package hébergé uniquement sur une forge GitLab
create_pkg("~/projets/monpkg", github_owner = NULL, ci = "gitlab")

# Dans un package existant
use_kpkg_github()   # .github/workflows/R-CMD-check.yaml et pkgdown.yaml
use_kpkg_gitlab()   # .gitlab-ci.yml
use_kpkg_pkgdown()  # _pkgdown.yml (site main à la racine, dev dans /dev)
use_kpkg_lintr()    # .lintr, lignes de 80 caractères au plus

# Mettre à jour les fichiers après une mise à jour de kpkg.r
use_kpkg_github(overwrite = TRUE)
use_kpkg_gitlab(overwrite = TRUE)
```

Chaque fichier d’intégration continue copié commence par la version de
kpkg.r dont il provient (`# Template kpkg.r 0.1.0: ...`).
[`kpkg_templates()`](https://kbosirany.github.io/kpkg.r/reference/kpkg_templates.md)
liste les templates disponibles.

L’auteur par défaut est donné par
[`kpkg_author()`](https://kbosirany.github.io/kpkg.r/reference/kpkg_author.md)
; pour en utiliser un autre, définir l’option `kpkg.r.author` (par
exemple dans `.Rprofile`) :

``` r

options(
  kpkg.r.author = person("Jane", "Doe", role = c("aut", "cre")),
  kpkg.r.github_owner = "janedoe"
)
```

Les conventions de branches, de versions et de publication sont décrites
dans
[`vignette("workflow", package = "kpkg.r")`](https://kbosirany.github.io/kpkg.r/articles/workflow.md).
