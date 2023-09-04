<p align="center">
  <img src="./refinery.png">
</p>

# refinery-action
Run [RustDB Refinery](https://github.com/rust-db/refinery) CLI as a GitHub action

## Usage

The default configuration installs the latest version of Refinery CLI and expects a `refinery.toml` configuration file in the root directory:

```yaml
steps:
- uses: walletconnect/refinery-action@1.0.0
```

A specific version of Refinery CLI can be installed:

```yaml
steps:
- uses: hashicorp/setup-terraform@v2
  with:
    refinery_version: 0.8.10
```

A different name for the configuration file can be specified:

```yaml
steps:
- uses: hashicorp/setup-terraform@v2
  with:
    config: './config/refinery.toml'
```

You can specify the name of an environment variable that contains the database URI:

```yaml
steps:
- uses: hashicorp/setup-terraform@v2
  with:
    db_uri_env_var: 'DATABASE_URL'
```

## Inputs

The action supports the following inputs:

| Name                   | Description                                                                                   | Default           |
|------------------------|-----------------------------------------------------------------------------------------------|-------------------|
| `migrations_directory` | Directory to run the action on, from the repo root                                            | `./migrations`    |
| `config`               | Path to the configuration file                                                                | `./refinery.toml` |
| `db_uri_env_var`       | Name of the environment variable that contains the database URI                               | --                |
| `single_transactions`  | Run migrations in a single transaction                                                        | `false`           |
| `target`               | Migrate to the specified target version                                                       | --                |
| `additional_args`      | Additional arguments to pass to the Refinery CLI                                              | --                |
| `refinery_version`     | Refinery CLI version to install                                                               | `latest`          |
| `github_token`         | GitHub token used for making authenticated requests to the GitHub API and avoid rate limiting | --                |

## Outputs

This action does not configure any outputs directly.

## Open Source Attribution

This action uses the following open source projects:

| Name     | License                                                            |
|----------|--------------------------------------------------------------------|
| refinery | [MIT](https://github.com/rust-db/refinery/blob/main/LICENSE)       |
| bash     | [GPL 3.0 or later](https://www.gnu.org/licenses/gpl-3.0.html)      |
| curl     | [curl license](https://curl.se/docs/copyright.html)                |
| git      | [GPL 2.0 or later](https://github.com/git/git/blob/master/COPYING) |
| jq       | [MIT](https://github.com/stedolan/jq/blob/master/COPYING)          |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
