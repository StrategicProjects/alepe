## R CMD check results

0 errors | 0 warnings | 0 notes locally (macOS, R 4.6.0) and on
GitHub Actions (Windows, macOS, Ubuntu release/devel/oldrel-1).

win-builder reports the one NOTE expected of a first submission:

* New submission.
* Possibly misspelled words in DESCRIPTION: Pernambuco, backoff,
  tibbles. "Pernambuco" is the Brazilian state whose Assembly publishes
  the data; the other two are standard terms in this context.
* Possibly invalid URL `https://CRAN.R-project.org/package=alepe`
  (the README's CRAN badge), which will resolve once this submission is
  accepted.

## Notes for reviewers

* The package wraps a public government open data API
  (https://dadosabertos.alepe.pe.gov.br). No authentication is required.
* All examples that reach the internet are guarded with
  `@examplesIf interactive()`; vignette chunks that reach the internet
  are disabled on CRAN via the NOT_CRAN environment variable. Tests run
  fully offline against local fixtures.
* Network failures never raise errors: functions warn and return
  zero-row tibbles, per the CRAN policy on internet resources.
