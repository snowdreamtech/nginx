# Docker Image Tags Reference

This document describes the Docker image tagging strategy for the nginx template project.

## Tag Naming Convention

All images use the format: `snowdreamtech/nginx:TAG`

Where `TAG` follows these patterns:

- **Variant-specific tags**: `TAG-variant` (e.g., `nightly-alpine`, `1.30.6-alpine`)
- **Default tags** (Debian only): `TAG` (e.g., `nightly`, `latest`, `1.26.3`)

## Supported Registries

All tags are pushed to two registries:

- **GitHub Container Registry**: `ghcr.io/snowdreamtech/nginx:TAG`
- **DockerHub**: `snowdreamtech/nginx:TAG`

## Tag Scenarios

### 1. Branch Builds (dev/main)

#### Push to `dev` branch

```bash
git push origin dev
```

**Generated tags:**

```
snowdreamtech/nginx:dev-alpine
snowdreamtech/nginx:dev-debian
snowdreamtech/nginx:dev              # ← Debian (default)
snowdreamtech/nginx:dev-rocky
```

#### Push to `main` branch

```bash
git push origin main
```

**Generated tags:**

```
snowdreamtech/nginx:main-alpine
snowdreamtech/nginx:latest-alpine
snowdreamtech/nginx:main-debian
snowdreamtech/nginx:latest-debian
snowdreamtech/nginx:main             # ← Debian (default)
snowdreamtech/nginx:latest           # ← Debian (default)
snowdreamtech/nginx:main-rocky
snowdreamtech/nginx:latest-rocky
```

---

### 2. Release Tags (Semantic Versioning)

#### Alpine Release

```bash
git tag alpine-v1.30.6
git push origin alpine-v1.30.6
```

**Generated tags:**

```
snowdreamtech/nginx:1.30.6-alpine
snowdreamtech/nginx:latest-alpine
```

#### Debian Release

```bash
git tag debian-v1.26.3
git push origin debian-v1.26.3
```

**Generated tags:**

```
snowdreamtech/nginx:1.26.3-debian
snowdreamtech/nginx:latest-debian
snowdreamtech/nginx:1.26.3           # ← Debian (default)
snowdreamtech/nginx:latest           # ← Debian (default)
```

#### Rocky Release

```bash
git tag rocky-v1.26.3
git push origin rocky-v1.26.3
```

**Generated tags:**

```
snowdreamtech/nginx:1.26.3-rocky
snowdreamtech/nginx:latest-rocky
```

---

### 3. Nightly Builds (Scheduled)

**Trigger:** Automatically every day at 17:00 UTC

**Generated tags:**

```
# Alpine
snowdreamtech/nginx:nightly-alpine
snowdreamtech/nginx:20261031-alpine

# Debian (with default tags)
snowdreamtech/nginx:nightly-debian
snowdreamtech/nginx:20261031-debian
snowdreamtech/nginx:nightly          # ← Debian (default)
snowdreamtech/nginx:20261031         # ← Debian (default)

# Rocky
snowdreamtech/nginx:nightly-rocky
snowdreamtech/nginx:20261031-rocky
```

---

## Tag Priority

Tags are generated with the following priority (higher number = higher priority):

| Priority | Type | Example Tags | Trigger |
|----------|------|--------------|---------|
| 1000 | Nightly | `nightly`, `nightly-alpine` | Schedule |
| 900 | Date | `20261031`, `20261031-alpine` | Schedule |
| 800 | Version | `1.30.6-alpine`, `1.26.3` | Tag push |
| 600 | Branch | `dev-alpine`, `main-debian` | Branch push |
| 200 | Latest | `latest`, `latest-alpine` | Main/Tag |

---

## Default Variant (Debian)

Debian is designated as the **default variant** (`is_latest: true`), which means:

✅ **Debian gets BOTH suffixed AND unsuffixed tags:**

```
snowdreamtech/nginx:nightly-debian   # Variant-specific
snowdreamtech/nginx:nightly          # Default (no suffix)

snowdreamtech/nginx:1.26.3-debian    # Variant-specific
snowdreamtech/nginx:1.26.3           # Default (no suffix)

snowdreamtech/nginx:latest-debian    # Variant-specific
snowdreamtech/nginx:latest           # Default (no suffix)
```

❌ **Alpine and Rocky get ONLY suffixed tags:**

```
snowdreamtech/nginx:nightly-alpine   # Variant-specific only
snowdreamtech/nginx:nightly-rocky    # Variant-specific only
```

---

## Usage Examples

### Pull the latest Debian image (default)

```bash
docker pull snowdreamtech/nginx:latest
# or
docker pull snowdreamtech/nginx:latest-debian
```

### Pull the latest Alpine image

```bash
docker pull snowdreamtech/nginx:latest-alpine
```

### Pull the latest Rocky image

```bash
docker pull snowdreamtech/nginx:latest-rocky
```

### Pull a specific version

```bash
# Alpine 1.30.6
docker pull snowdreamtech/nginx:1.30.6-alpine

# Debian 1.26.3 (two ways)
docker pull snowdreamtech/nginx:1.26.3-debian
docker pull snowdreamtech/nginx:1.26.3

# Rocky 1.26.3
docker pull snowdreamtech/nginx:1.26.3-rocky
```

### Pull nightly builds

```bash
# Alpine nightly
docker pull snowdreamtech/nginx:nightly-alpine

# Debian nightly (two ways)
docker pull snowdreamtech/nginx:nightly-debian
docker pull snowdreamtech/nginx:nightly

# Rocky nightly
docker pull snowdreamtech/nginx:nightly-rocky
```

---

## Tag Lifecycle

### Development Flow

```
1. Push to dev → nginx:dev-alpine, nginx:dev-debian, nginx:dev, nginx:dev-rocky
2. Push to main → nginx:main-alpine, nginx:latest-alpine, nginx:main-debian, nginx:latest-debian, nginx:main, nginx:latest, nginx:main-rocky, nginx:latest-rocky
3. Create tag → nginx:VERSION-variant, nginx:latest-variant (+ unsuffixed for Debian)
```

### Release Flow (with Release Please)

```
1. Merge PR to main → Release Please creates release PR
2. Merge release PR → Release Please creates tags (alpine-vX.Y.Z, debian-vX.Y.Z, rocky-vX.Y.Z)
3. Tag push triggers build → Images published with version tags
```

---

## Matrix Configuration

The workflow uses a matrix strategy with three variants:

```yaml
matrix:
  include:
    - variant: alpine
      version: "1.30.6"
      is_latest: false

    - variant: debian
      version: "1.26.3"
      is_latest: true    # ← Default variant

    - variant: rocky
      version: "1.26.3"
      is_latest: false
```

Only the variant with `is_latest: true` receives unsuffixed tags.

---

## Metadata Action Configuration

The key configuration that enables this tagging strategy:

```yaml
images: |
  name=ghcr.io/snowdreamtech/nginx,enable=true
  name=snowdreamtech/nginx,enable=true
flavor: |
  latest=false
  prefix=
  suffix=-${{ matrix.variant }}  # ← Adds variant suffix to all tags
```

For Debian (is_latest), additional rules generate unsuffixed tags:

```yaml
type=raw,enable=${{ matrix.is_latest }},priority=1000,prefix=,suffix=,pattern=nightly
```

This creates both `nightly-debian` (from flavor suffix) and `nightly` (from this rule).
