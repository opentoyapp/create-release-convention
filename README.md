# Release Automation Toolkit

Created for those who struggle with setting up release automation and end up manually updating versions and creating release notes.  
Built on top of [`semantic-release`](https://github.com/semantic-release/semantic-release).
With just one click of the following commands, your project's release automation setup will be complete.

```bash
npx create-release-convention
yarn create release-convention
pnpm create release-convention
```

After running this, the moment you push to the `main` branch, Github Actions will automatically version your project, create release notes, and even generate a `CHANGELOG.md` file.
