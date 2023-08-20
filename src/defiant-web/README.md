# Defiant Web

## Requirements

* Rust (stable)
* PostgreSQL

## Setup

```zsh
% psql -U xxx -c "CREATE USER <USER> WITH PASSWORD \"<PASSWORD>\";"
% psql -U xxx -c "ALTER USER <USER> WITH SUPERUSER CREATEDB LOGIN;"
% psql -U xxx -c "CREATE DATABASE <NAME> WITH TEMPLATE = template0 ENCODING = UTF8;"
% psql -U xxx -c "ALTER DATABASE <NAME> OWNER TO <USER>;"
% psql <DATABASE_URL> -c "CREATE EXTENSION IF NOT EXISTS \"pg_stat_statements\";"
% psql <DATABASE_URL> -c "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";"
```

```zsh
% cp .env{.sample,}
% make setup
% make scheme:migration:commit
```

## Build

```zsh
% make build
```

## Test

```zsh
% ENV= test make schema:migration:commit
% make test

: or run the indivisual test like so:
% cargo test model::namespace::test -- --nocapture
```


## License

`AGPL-3.0-or-later`

```txt
Defiant Web
Copyright (C) 2023 Yasuhiro Яша Asaka

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
```
