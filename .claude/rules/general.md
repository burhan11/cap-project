# General rules

## Verification (after every change)
1. `cds compile db srv` must pass with no errors
2. Start `cds watch`, confirm it starts and all CSVs load, then stop it
3. If tests exist for the touched area, run `npm test`

## Safety
- Never hardcode credentials, URLs, or tenant IDs; use env/config
- Never edit package-lock.json, mta.yaml, or xs-security.json unless asked

## Response
- End each task with a short table: files changed, what changed, how verified