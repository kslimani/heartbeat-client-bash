[![MIT license](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

# Heartbeat bash client

A simple HTTP client for [Heartbeat](https://github.com/kslimani/heartbeat) back-end application.

## Installation

Download shell script from github.

Example :

```shell
curl "https://raw.githubusercontent.com/kslimani/heartbeat-client-bash/master/heartbeat.sh" > /usr/local/bin/hb && chmod +x /usr/local/bin/hb
```

_(or clone this project and place the script where it suits your needs)_

## Configuration

Default configuration file is `$HOME/.heartbeat`.

Type `hb configure` and follow instructions to enter api url and api key.

To bypass query inputs type `hb configure <api_url> <api_key>` .

To bypass configuration file, use `HEARTBEAT_URL` and `HEARTBEAT_KEY` env variables.

## Usage

Type `hb update <device_name> <service_name> <status>` to update device service status.

Ex: `hb update server01 acme-srv up`

## License

The MIT License (MIT). Please see [License File](LICENSE) for more information.
