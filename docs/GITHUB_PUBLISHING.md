# GitHub Publishing Procedure

## Repository Decision

Create a new empty repository, preferably private at first:

```text
Repository name: hundred-km-goal
Visibility: Private during construction
README: Do not generate online if README.md already exists locally
License: Do not generate online if LICENSE already exists locally
```

## Local Push

From the project root:

```bash
git init
git branch -M main
git status
git add README.md pubspec.yaml analysis_options.yaml .gitignore LICENSE lib test docs rdos scripts .github
git commit -m "feat: initialize 100km goal app under RDOS"
git remote add origin https://github.com/YOUR_USERNAME/hundred-km-goal.git
git push -u origin main
```

## Inspection After Push

```text
GitHub Inspection
├── README renders correctly
├── No generated folders are visible
├── No secret files are visible
├── Repository description is clear
└── Visibility is intentional
```
