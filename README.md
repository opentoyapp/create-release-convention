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

## Prerequisites

Before using this toolkit, you need to set up a `GH_TOKEN` in your Github repository:

1. Go to your Github account settings
2. Navigate to Developer settings > Personal access tokens > Tokens (classic)
3. Generate a new token with `repo` scope
4. Add the token to your repository's secrets as `GH_TOKEN`
