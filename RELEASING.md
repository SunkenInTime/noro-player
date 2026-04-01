# Releasing Noro Player

This skin shows an in-app `UPDATE` badge when `latest.ini` advertises a newer `VersionCode` than the installed skin.

## Release version files

These files stay in sync for every release:

- `NoroPlayer/Player.ini`
- `NoroPlayer/@Resources/Variables.inc`
- `latest.ini`
- `RMSKIN.ini`

## Version format

- `VersionLabel` is the user-facing version string, such as `1.0.1`.
- `VersionCode` is the numeric value Rainmeter compares, such as `10001`.

Use a monotonically increasing `VersionCode` so update checks always compare cleanly.

## Publish a release

### Easiest way: Run workflow button

In GitHub, open the `Actions` tab, choose `Release Rainmeter Skin`, click `Run workflow`, and choose one of:

- `patch`
- `minor`
- `major`

The workflow will:

1. Read the current version from `latest.ini`.
2. Calculate the next semantic version.
3. Update `Player.ini`, `Variables.inc`, `latest.ini`, and `RMSKIN.ini`.
4. Commit that version bump back to the selected branch.
5. Create the matching tag, such as `v1.0.1`.
6. Build `NoroPlayer.rmskin`.
7. Publish the GitHub Release and upload the fixed asset filename.

Examples:

- `patch`: `1.0.0` -> `1.0.1`
- `minor`: `1.0.1` -> `1.1.0`
- `major`: `1.1.3` -> `2.0.0`

### CLI way: push a tag manually

1. Manually bump the release version files.
2. Create a tag that matches the release version, such as `v1.0.1`.
3. Push the commit and tag to GitHub.

The workflow strips the leading `v` before writing the `.rmskin` package version, so the tag can stay `v1.0.1` while the skin version remains `1.0.1`.

```powershell
git tag v1.0.1
git push origin master
git push origin v1.0.1
```

## What GitHub Actions does

When a `v*` tag is pushed, `.github/workflows/release.yml`:

1. Stages the skin into a temporary `Skins/NoroPlayer` package layout.
2. Builds a `.rmskin` package with `2bndy5/rmskin-action`.
3. Uploads a fixed-name asset: `NoroPlayer.rmskin`.

That fixed filename is important because the skin links to:

`https://github.com/SunkenInTime/noro-player/releases/latest/download/NoroPlayer.rmskin`

## Update checker source

The skin reads the latest version from:

`https://raw.githubusercontent.com/SunkenInTime/noro-player/master/latest.ini`

If you ever change the repository owner, name, or default branch, update the URLs in `NoroPlayer/@Resources/Variables.inc`.
