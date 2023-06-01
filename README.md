# action-update-dprint-plugins

[![CI](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml?query=branch%3Amain++)

Update dprint plugins in dprint.json config file

## Usage

For example of `.github/workflows/dprint-update-plugin.yml`

```yaml
name: Update dprint plugins
on:
  push:
    branches: ['main']
    paths:
      - '.github/workflows/dprint-update-plugin.yml'
  schedule:
  - cron: '0 17 * * *'
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

permissions:
  contents: read

# Allow one concurrent updates
concurrency:
  group: 'dprint'
  cancel-in-progress: true

jobs:
  update:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - uses: kachick/action-update-dprint-plugins@v0.1.0
        # with:
          # auto-merge: false # default: true
```

## Parameters

| name       | default | options                  | description                                                                      |
| ---------- | ------- | ------------------------ | -------------------------------------------------------------------------------- |
| auto-merge | 'true'  | 'true', 'false' # string | if no change exist even after `dprint fmt`, the updateing PR will be auto merged |

## Motivation

- [renovate solution is here](https://github.com/kachick/renovate-config-dprint), but it [can not update some plugins](https://github.com/kachick/renovate-config-dprint/issues/11) as example of dprint-plugin-prettier
