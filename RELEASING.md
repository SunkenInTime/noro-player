# Releasing RetroTouchPlayer

This skin shows an in-app `UPDATE` badge when `latest.ini` advertises a newer `VersionCode` than the installed skin.

## Files to bump for each release

Update these files to the same release version before tagging:

- `RetroTouchPlayer/Player.ini`
  - `[Metadata]`
  - `Version=1.0.0`
- `RetroTouchPlayer/@Resources/Variables.inc`
  - `SkinVersionCode=10000`
  - `SkinVersionLabel=1.0.0`
- `latest.ini`
  - `VersionCode=10000`
  - `VersionLabel=1.0.0`
- `RMSKIN.ini`
  - `Version=1.0.0`

## Version format

- `VersionLabel` is the user-facing version string, such as `1.0.1`.
- `VersionCode` is the numeric value Rainmeter compares, such as `10001`.

Use a monotonically increasing `VersionCode` so update checks always compare cleanly.

## Publish a release

1. Commit the version bump.
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

1. Stages the skin into a temporary `Skins/RetroTouchPlayer` package layout.
2. Builds a `.rmskin` package with `2bndy5/rmskin-action`.
3. Uploads a fixed-name asset: `RetroTouchPlayer.rmskin`.

That fixed filename is important because the skin links to:

`https://github.com/SunkenInTime/rainmeter-touch-player/releases/latest/download/RetroTouchPlayer.rmskin`

## Update checker source

The skin reads the latest version from:

`https://raw.githubusercontent.com/SunkenInTime/rainmeter-touch-player/master/latest.ini`

If you ever change the repository owner, name, or default branch, update the URLs in `RetroTouchPlayer/@Resources/Variables.inc`.
