# Balboa

### Install
```console
bundle install
```

## Configure your environment

```sh
export PUNCH_EMAIL='my@email.com'
export PUNCH_PASSWORD='mysecret'

# Might be a good idea if you'll work long on a project
export PUNCH_PROJECT='My Project'
```

## Get in action!

```console
FROM=2014-01-23 TO=2014-01-26 ./punch
```

You can also change the project per invocation:

```console
PUNCH_PROJECT='Other Project' FROM=2014-01-23 TO=2014-01-26 ./punch
```
