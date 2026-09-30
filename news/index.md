# Changelog

## alepe 0.1.1

- [`alepe_staff()`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md)
  gains `status = "lent"` (API term `"efetivo-cedido"`): the Assembly’s
  own permanent staff lent to other bodies. The API publishes them with
  `vinculo` `"Efetivo"`, so this server-side filter is the only way to
  single them out.
  [`alepe_positions()`](https://strategicprojects.github.io/alepe/reference/alepe_positions.md)
  does not accept it, because `/cargos` ignores the value and returns
  every status.
- An invalid `status` in
  [`alepe_staff()`](https://strategicprojects.github.io/alepe/reference/alepe_staff.md)
  /
  [`alepe_positions()`](https://strategicprojects.github.io/alepe/reference/alepe_positions.md)
  (and their aliases) is now an error, as documented. It used to be
  evaluated inside the fetch layer’s error handler and surfaced as a
  warning that the API could not be reached, followed by an empty
  tibble.
- Author metadata: the maintainer’s name is spelled André Leite; Marcos
  Wasiliew’s e-mail address is updated; ORCIDs added for Marcos Wasiliew
  and Júlia Nascimento Barreto.

## alepe 0.1.0

CRAN release: 2026-08-20

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
