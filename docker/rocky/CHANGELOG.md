# Changelog

## [1.26.3](https://github.com/snowdreamtech/nginx/compare/rocky-v1.26.3...rocky-v1.26.3) (2026-08-13)


### 🐛 Bug Fixes

* remove static version defaults from OCI image labels to use variable injection exclusively ([da5645a](https://github.com/snowdreamtech/nginx/commit/da5645ad4d48467290235abbbd9f31ba70bf690f))
* use ghcr.io for base images to avoid rate limits ([9f1d73a](https://github.com/snowdreamtech/nginx/commit/9f1d73a75a61f2f368f5572c4bd28f4c92ef8fd5))


### 🛠 Refactoring

* remove redundant version LABEL blocks from Dockerfiles ([ca8b798](https://github.com/snowdreamtech/nginx/commit/ca8b798cc74f6705d4cc1e0435def3a60c3a71c4))


### ♻️ Miscellaneous Chores

* add 0-git-keep.sh to prevent empty entrypoint.d directories ([ce77247](https://github.com/snowdreamtech/nginx/commit/ce77247762becc1edf85ec7b57747d3f3127044a))
* **docker:** ignore unavailable repos for rocky build ([a6b6b6e](https://github.com/snowdreamtech/nginx/commit/a6b6b6e5b2288cfeb6b2777902b85e7e5f37f2c3))
* merge upstream/dev into dev ([230964e](https://github.com/snowdreamtech/nginx/commit/230964e703d2b6fe959e17b87ee864634e26b95e))
* release main ([5a92edb](https://github.com/snowdreamtech/nginx/commit/5a92edb4ba76b04ee6de7369e9471f785849a7ae))
* release main ([4011a21](https://github.com/snowdreamtech/nginx/commit/4011a21a23395acc9545168c95ca0ec5c867e7d3))
* release main ([d52be5c](https://github.com/snowdreamtech/nginx/commit/d52be5cf0c5cff45f7f72e973d62c94b48855e1b))
* release main ([f66597a](https://github.com/snowdreamtech/nginx/commit/f66597a5feae95e8853f4cc730c81e93e172f6ca))
* release main ([b3a5cc9](https://github.com/snowdreamtech/nginx/commit/b3a5cc9ef0a64a7bc04ed7c2acf0cca5327c5c26))
* **release:** deduplicate CHANGELOG headers ([c2bba24](https://github.com/snowdreamtech/nginx/commit/c2bba247dca89a31accc6e70c5e48b16170b1ce5))
* **release:** deduplicate CHANGELOG headers ([4f07b71](https://github.com/snowdreamtech/nginx/commit/4f07b71194f58ba214f1fb60ce0dc56d71c499e2))
* **release:** deduplicate CHANGELOG headers ([3068d88](https://github.com/snowdreamtech/nginx/commit/3068d883bc6167773d046d3b2b0e4c479e4fee39))
* **release:** deduplicate CHANGELOG headers ([82be3d5](https://github.com/snowdreamtech/nginx/commit/82be3d5576b65b7f69b1a9afb8604f2c8f0e47f7))
* **speckit:** manual auto-commit trigger ([5f8a5a9](https://github.com/snowdreamtech/nginx/commit/5f8a5a9cba5d6bd42a65eaabfecd6e18b01aeeb0))

## [1.26.3](https://github.com/snowdreamtech/nginx/compare/rocky-v1.26.3...rocky-v1.26.3) (2026-06-26)


### 🐛 Bug Fixes

* copy native default html pages to unified NGINX_WEB_ROOT ([83e18c2](https://github.com/snowdreamtech/nginx/commit/83e18c2081ebf6ce0e17fa02edb93ad3eeec8567))


### 🛠 Refactoring

* standardize Nginx web root to /var/www/html across all OS variants ([c4b81ba](https://github.com/snowdreamtech/nginx/commit/c4b81bae563ef060860cc7e2279f8508e6d82c93))
