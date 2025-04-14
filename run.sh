#!/bin/bash

# Initialize git repository
if [ ! -d '.git' ]; then
  echo git init
fi

# Initialize packages if package.json doesn't exist
if [ ! -e 'package.json' ]; then
  npm init -y
  npm i
fi

# For yarn users
if [ -e yarn.lock ]; then
  yarn add -D semantic-release @semantic-release/changelog @semantic-release/git

# For pnpm users
elif [ -e pnpm-lock.yaml ]; then
  pnpm add -D semantic-release @semantic-release/changelog @semantic-release/git

# For npm users
elif [ -e package-lock.json ]; then
  npm i -D semantic-release @semantic-release/changelog @semantic-release/git

fi

# Create .releaserc file
echo "{
  "branches": [
    "main"
  ],
  "tagFormat": "release-\${version}",
  "plugins": [
    [
      "@semantic-release/commit-analyzer",
      {
        "preset": "conventionalcommits",
        "releaseRules": [
          {
            "type": "feat",
            "release": "minor"
          },
          {
            "type": "fix",
            "release": "patch"
          },
          {
            "type": "docs",
            "release": "patch"
          },
          {
            "type": "style",
            "release": "patch"
          },
          {
            "type": "refactor",
            "release": "patch"
          },
          {
            "type": "perf",
            "release": "patch"
          },
          {
            "type": "test",
            "release": false
          },
          {
            "type": "build",
            "release": false
          },
          {
            "type": "ci",
            "release": false
          },
          {
            "type": "chore",
            "release": "major"
          },
          {
            "type": "revert",
            "release": "patch"
          }
        ]
      }
    ],
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/npm",
    [
      "@semantic-release/git",
      {
        "assets": [
          "package.json",
          "CHANGELOG.md"
        ],
        "message": "ci: \${nextRelease.version}"
      }
    ],
    "@semantic-release/github"
  ]
}
" > .releaserc

mkdir -p .github/workflows

echo "name: Release

on:
  push:
    branches:
      - main

permissions:
  contents: read # for checkout

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    permissions:
      contents: write # to be able to publish a GitHub release
      issues: write # to be able to comment on released issues
      pull-requests: write # to be able to comment on released pull requests
      id-token: write # to enable use of OIDC for npm provenance
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 'lts/*'
      - name: Install dependencies
        env:
          HUSKY: 0
        run: yarn
      - name: Verify the integrity of provenance attestations and registry signatures for installed dependencies
        run: npm audit signatures
      - name: Release
        env:
          GITHUB_TOKEN: \$\{\{ secrets.GH_TOKEN }}
        run: npx semantic-release
" > .github/workflows/release.yml