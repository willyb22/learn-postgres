#!/bin/bash

# exit if a command exits with non-zero status
set -e

export PGPASSWORD=$POSTGRES_PASSWORD

# check if migrations directory exists
MIGRATIONS_DIR="/app/migrations"
if [ ! -d "$MIGRATIONS_DIR" ]; then
    echo "Migrations directory not found: $MIGRATIONS_DIR"
    exit 1
fi
# do migration
for migration in $MIGRATIONS_DIR/*.sql; do
    echo "Applying migration: $migration"
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f "$migration"
done

echo "All migrations applied successfully"