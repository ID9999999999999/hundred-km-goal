# Security and Privacy Model

## Data Classification

| Data Type | Storage | Risk | Rule |
|---|---|---:|---|
| GPS route points | Local device | High | Never upload in prototype |
| Session distance | Local device | Medium | Display only to user |
| Duration and speed | Local device | Medium | Display only to user |
| Tokens / API keys | Not used | Critical | Must never exist in repository |

## Location Permission

The app requests location permission to record the user's own activity. No backend upload is implemented.

## Anti-Secret Rules

The repository excludes:

```text
.env
*.pem
*.key
*.jks
*.keystore
local.properties
key.properties
secrets.json
```

## Integrity Limits

The app filters obvious GPS noise and impossible speed jumps. This is not official anti-cheat. It is a personal honesty layer.
