# action-update-dprint-plugins

[![CI](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml/badge.svg?branch=main)](https://github.com/kachick/action-update-dprint-plugins/actions/workflows/validate.yml?query=branch%3Amain++)

GitHub Action to update [dprint](https://github.com/dprint/dprint) plugins in `dprint.json`

This project is in the experimental stage.

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
  contents: write
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
      - id: update-dprint-plugins
        uses: kachick/action-update-dprint-plugins@main
        with:
          base-branch: 'main'
          github-token: "${{ secrets.GITHUB_TOKEN }}"
      # Enable `Allow auto-merge` in your repository settings if you need following steps
      - name: Merge sent PR
        if: ${{ steps.update-dprint-plugins.outputs.pr_url != '' }}
        run: gh pr merge --auto "${{ steps.update-dprint-plugins.outputs.pr_url }}"
```

## Parameters

All options should be specified with string. So true/false should be 'true'/'false'

| name         | default | options                           | description                                       |
| ------------ | ------- | --------------------------------- | ------------------------------------------------- |
| base-branch  | (null)  | e.g 'main'                        | The branch into which you want updating PR merged |
| github-token | (null)  | e.g "${{ secrets.GITHUB_TOKEN }}" | The token will be used to create PR               |

## Motivation

- A solution with [renovatebot](https://github.com/renovatebot/renovate) is [here](https://github.com/kachick/renovate-config-dprint), but it [may not update some plugins](https://github.com/kachick/renovate-config-dprint/issues/11) like [dprint-plugin-prettier](https://github.com/dprint/dprint-plugin-prettier)
