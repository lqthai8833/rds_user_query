# migrations/

SQL files dropped here are picked up automatically by
`.github/workflows/rds-migration-apply.yml` on push to `main`.

Convention: prefix files with a zero-padded sequence number so apply order
is deterministic, e.g. `0001_add_component_index.sql`, `0002_backfill_x.sql`.

Flow on push:
1. `apply-qa` job applies every `.sql` file changed by the push, against the
   `qa` GitHub Environment's database (in file-name order).
2. `apply-prod` job runs the same files against `prod`, but only after
   `apply-qa` succeeds and the `prod` environment's required reviewers (set
   in repo Settings -> Environments, not in this repo) approve.

There's no migration-tracking table -- "already applied" is determined by
git history (only files added/changed by the triggering push are run), so
write files idempotently (`IF NOT EXISTS`, etc.) the same way the RBAC
scripts in cloudops-terraform-modules/aws/rds/rbac do.
