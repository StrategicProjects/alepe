## Submission

This is a patch release (0.1.0 was accepted on 2026-08-20). It fixes a
bug where an invalid `status` argument was reported as a network
failure instead of an input error, adds one filter value exposed by the
API, and updates author metadata (spelling of the maintainer's name,
one co-author's e-mail, ORCIDs). The maintainer's e-mail address is
unchanged.

## R CMD check results

0 errors | 0 warnings | 0 notes locally (macOS, R 4.6.0) and on
GitHub Actions (Windows, macOS, Ubuntu release/devel/oldrel-1).

## Reverse dependencies

There are no reverse dependencies.

## Notes for reviewers

* The package wraps a public government open data API
  (https://dadosabertos.alepe.pe.gov.br). No authentication is required.
* All examples that reach the internet are guarded with
  `@examplesIf interactive()`; vignette chunks that reach the internet
  are disabled on CRAN via the NOT_CRAN environment variable. Tests run
  fully offline against local fixtures.
* Network failures never raise errors: functions warn and return
  zero-row tibbles, per the CRAN policy on internet resources.
