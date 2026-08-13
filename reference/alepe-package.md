# alepe: Access the Open Data API of the Legislative Assembly of Pernambuco

A tidy interface to the open data API of the Legislative Assembly of the
State of Pernambuco, Brazil ('ALEPE',
<https://dadosabertos.alepe.pe.gov.br>). Retrieve data on
representatives, staff, positions, departments, remuneration, contracts,
procurement processes, and legislative propositions as tibbles with
clean names and parsed column types. Requests are cached locally and
retried with exponential backoff; network failures are handled
gracefully.

## Package options

- `alepe.quiet`: suppress informational messages. Defaults to `TRUE` in
  non-interactive sessions.

- `alepe.cache_dir`: cache location. Defaults to
  `tools::R_user_dir("alepe", "cache")`.

- `alepe.cache_max_age`: cache expiry in seconds. Defaults to 6 hours.

- `alepe.max_tries`: maximum request attempts. Defaults to 3, with
  exponential backoff between attempts.

- `alepe.timeout`: request timeout in seconds. Defaults to 60; the
  slowest endpoint (`/licitacoes`) regularly needs close to 30 s.

## See also

Useful links:

- <https://github.com/StrategicProjects/alepe>

- <https://strategicprojects.github.io/alepe/>

- Report bugs at <https://github.com/StrategicProjects/alepe/issues>

## Author

**Maintainer**: Andre Leite <leite@castlab.org>
([ORCID](https://orcid.org/0000-0002-4718-9766))

Authors:

- Andre Leite <leite@castlab.org>
  ([ORCID](https://orcid.org/0000-0002-4718-9766))

- Marcos Wasiliew <marcos.wasiliew@sepe.pe.gov.br>

- Hugo Vasconcelos <hugo.vasconcelos@ufpe.br>
  ([ORCID](https://orcid.org/0000-0001-6249-0920))

- Carlos Amorim <carlos.agaf@ufpe.br>
  ([ORCID](https://orcid.org/0000-0001-6315-8305))

- Diogo Bezerra <diogo.bezerra@ufpe.br>
  ([ORCID](https://orcid.org/0000-0002-1216-8674))

- Júlia Nascimento Barreto <juliabarreto@gd.seplag.pe.gov.br>
