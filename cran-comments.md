## R CMD check results

0 errors | 0 warnings | 0 notes

* This is a new release.

## Possibly invalid URLs

* `https://CRAN.R-project.org/package=alepe` (README badge) will resolve
  once this first submission is accepted.

## Notes for reviewers

* The package wraps a public government open data API
  (https://dadosabertos.alepe.pe.gov.br). No authentication is required.
* All examples that reach the internet are guarded with
  `@examplesIf interactive()`; vignette chunks that reach the internet
  are disabled on CRAN via the NOT_CRAN environment variable. Tests run
  fully offline against local fixtures.
* Network failures never raise errors: functions warn and return
  zero-row tibbles, per the CRAN policy on internet resources.
