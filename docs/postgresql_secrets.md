# PostgreSQL Secrets Configuration

## Required Secrets in ansible/secrets_production.yml and ansible/secrets_staging.yml

Add these PostgreSQL-related secrets to your encrypted secrets files:

```yaml
# PostgreSQL HA Cluster Passwords
postgresql_root_password: "your-secure-postgres-password"
postgresql_repmgr_password: "your-secure-repmgr-password" 
postgresql_pgpool_admin_password: "your-secure-pgpool-admin-password"

# Example app database passwords (add as needed)
example_app_db_password: "your-app-specific-db-password"
```

## How to Edit Encrypted Secrets

```bash
# Edit production secrets
ansible-vault edit ansible/secrets_production.yml

# Edit staging secrets  
ansible-vault edit ansible/secrets_staging.yml
```

## Password Generation

Generate secure passwords using:
```bash
# Generate 32-character random password
openssl rand -base64 32

# Or use pwgen if available
pwgen -s 32 1
```

## Database Connection Strings

**For applications connecting via Pgpool (recommended):**
- Host: `postgresql-ha-pgpool.default.svc.cluster.local`
- Port: `5432`
- Connection pooling and load balancing included

**For applications connecting directly to primary:**
- Host: `postgresql-ha-postgresql.default.svc.cluster.local` 
- Port: `5432`
- Direct connection to primary node