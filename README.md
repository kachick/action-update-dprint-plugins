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
        uses: kachick/action-update-dprint-plugins@v1-beta
        with:
          base-branch: 'main'
          github-token: '${{ secrets.GITHUB_TOKEN }}'
      # Enable `Allow auto-merge` in your repository settings if you need following steps
      - name: Merge sent PR
        # Merge if `dprint fmt` does not make any diff even after updating plugins
        if: ${{ steps.update-dprint-plugins.outputs.pr_url != '' && steps.update-dprint-plugins.outputs.fmt == 'false' }}
        run: gh pr merge --auto --squash --delete-branch "${{ steps.update-dprint-plugins.outputs.pr_url }}"
        env:
          GITHUB_TOKEN: '${{ secrets.GITHUB_TOKEN }}'
```

## Input Parameters

All options should be specified with string. So true/false should be 'true'/'false'

| name           | default       | options                           | description                                       |
| -------------- | ------------- | --------------------------------- | ------------------------------------------------- |
| base-branch    | (null)        | e.g 'main'                        | The branch into which you want updating PR merged |
| github-token   | (null)        | e.g "${{ secrets.GITHUB_TOKEN }}" | The token will be used to create PR               |
| dprint-version | (null)        | e.g '0.36.1'                      | Specific dprint version to use                    |
| config-path    | 'dprint.json' | e.g 'dprint-ci.json'              | Specific dprint config to use                     |

## Outputs

| name   | patterns                                        | description                                                         |
| ------ | ----------------------------------------------- | ------------------------------------------------------------------- |
| pr_url | e.g. '`https://github.com/owner/repos/pull/42`' | Sent PR URL                                                         |
| fmt    | 'true'/'false`                                  | Return true if diff was made in `dprint fmt` after updating plugins |

## Motivation

- A solution with [renovatebot](https://github.com/renovatebot/renovate) is [here](https://github.com/kachick/renovate-config-dprint), but it [may not update some plugins](https://github.com/kachick/renovate-config-dprint/issues/11) like [dprint-plugin-prettier](https://github.com/dprint/dprint-plugin-prettier)
