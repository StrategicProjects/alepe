# Changelog

## alepe 0.1.0

- Initial release.

- Tidy wrappers for all documented v1 endpoints of the ALEPE open data
  API: representatives, staff, positions, departments, remuneration,
  contracts, procurements, and legislative propositions (bills,
  indications, requests).

- Local response cache, exponential-backoff retries, graceful failures
  compliant with the CRAN policy on internet resources.

- Every endpoint function has a Portuguese alias named after the API
  endpoint it wraps
  ([`alepe_servidores()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
  [`alepe_contratos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
  [`alepe_projetos()`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md),
  …); see
  [`?alepe_aliases`](https://strategicprojects.github.io/alepe/reference/alepe_aliases.md).
