# Heartbeat bash client

A simple HTTP client for [Heartbeat](https://github.com/kslimani/heartbeat) back-end application.

## Installation

Download shell script from github.

Example :

```shell
curl "https://raw.githubusercontent.com/kslimani/heartbeat-client-bash/master/heartbeat.sh" > /usr/local/bin/hb && chmod +x /usr/local/bin/hb
```

## Configuration

Default configuration file is `$HOME/.heartbeat`.

Type `hb configure` and follow instructions to enter api url and api key.

To bypass query inputs type `hb configure <api_url> <api_key>` .

To bypass configuration file, use `HEARTBEAT_URL` and `HEARTBEAT_KEY` env variables.

## Usage

Type `hb update <device_name> <service_name> <status>` to update device service status.

Ex: `hb update server01 acme-srv up`
