# action-update-dprint-plugins

[![CI](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml?query=branch%3Amain++)

GitHub Action to update [dprint](https://github.com/dprint/dprint) plugins in `dprint.json`

## Usage

An example workflow in your repository, assuming it is named `.github/workflows/dprint-update-plugin.yml`.

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
  pull-requests: write

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
        with:
          base-branch: 'main'
          # auto-merge: false # default: true
```

## Parameters

All options should be specified with string. So true/false should be 'true'/'false'

| name        | default | options         | description                                                                    |
| ----------- | ------- | --------------- | ------------------------------------------------------------------------------ |
| base-branch | (null)  | e.g 'main'      | The branch into which you want updating PR merged                              |
| auto-merge  | 'true'  | 'true', 'false' | The updating PR will be auto merged if no change exist even after `dprint fmt` |

## Motivation

- A solution with [renovatebot](https://github.com/renovatebot/renovate) is [here](https://github.com/kachick/renovate-config-dprint), but it [may not update some plugins](https://github.com/kachick/renovate-config-dprint/issues/11) like [dprint-plugin-prettier](https://github.com/dprint/dprint-plugin-prettier)
