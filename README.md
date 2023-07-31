# action-update-dprint-plugins

**I do NOT recommend to use this action now, because some updating will not work.**\
**See <https://github.com/dprint/dprint-plugin-prettier/issues/56> for further detail**

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
    # Run at 17:00 UTC every Monday
    - cron: '0 17 * * 1'
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

permissions:
  contents: write
  pull-requests: write

# Allow one concurrent dprint updater
concurrency:
  group: 'update-dprint'
  cancel-in-progress: true

jobs:
  update:
    runs-on: ubuntu-latest
    timeout-minutes: 15
    steps:
      - id: update-dprint-plugins
        uses: kachick/action-update-dprint-plugins@v2.0.0
        with:
          base-branch: 'main'
          dprint-version: '0.40.1'

      # Enable `Allow auto-merge` in your repository settings if you need following steps
      - name: Merge sent PR
        # Checking `dprint fmt` did not make any diff even after updating plugins
        if: ${{ steps.update-dprint-plugins.outputs.pr_url != '' && steps.update-dprint-plugins.outputs.fmt == 'false' }}
        run: gh pr merge --auto --squash --delete-branch "${{ steps.update-dprint-plugins.outputs.pr_url }}"
        env:
          # Need to be replaced to your PAT if need to approve or need to trigger other actions
          GITHUB_TOKEN: '${{ secrets.GITHUB_TOKEN }}'
```

## Preparation

Need to add following permissions if you use GITHUB_TOKEN

```yaml
permissions:
  contents: write
  pull-requests: write
```

Enable the following options in your repository settings

- Enable `Allow GitHub Actions to create and approve pull requests`
- Enable `Allow auto-merge` if you need auto merging

## Input Parameters

All options should be specified with string. So true/false should be 'true'/'false'

| name           | default             | options                       | description                                         |
| -------------- | ------------------- | ----------------------------- | --------------------------------------------------- |
| base-branch    | (null)              | e.g 'main'                    | The branch into which you want updating PR merged   |
| github-token   | ${{ github.token }} | e.g '${{ secrets.YOUR_PAT }}' | The token will be used to create PR                 |
| dprint-version | (null)              | e.g '0.40.1'                  | Specific dprint version to use. Should be specified |
| config-path    | 'dprint.json'       | e.g 'dprint-ci.json'          | Specific dprint config to use                       |

## Outputs

| name   | patterns                                        | description                                                         |
| ------ | ----------------------------------------------- | ------------------------------------------------------------------- |
| pr_url | e.g. '`https://github.com/owner/repos/pull/42`' | Sent PR URL                                                         |
| fmt    | 'true'/'false`                                  | Return true if diff was made in `dprint fmt` after updating plugins |

## Motivation

- A solution with [renovatebot](https://github.com/renovatebot/renovate) is [here](https://github.com/kachick/renovate-config-dprint), but it [may not update some plugins](https://github.com/kachick/renovate-config-dprint/issues/11) like [dprint-plugin-prettier](https://github.com/dprint/dprint-plugin-prettier)
