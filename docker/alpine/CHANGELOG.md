# Changelog

## [1.30.3](https://github.com/snowdreamtech/nginx/compare/alpine-v1.30.3...alpine-v1.30.3) (2026-06-26)


### 🐛 Bug Fixes

* copy native default html pages to unified NGINX_WEB_ROOT ([83e18c2](https://github.com/snowdreamtech/nginx/commit/83e18c2081ebf6ce0e17fa02edb93ad3eeec8567))


### 🛠 Refactoring

* standardize Nginx web root to /var/www/html across all OS variants ([c4b81ba](https://github.com/snowdreamtech/nginx/commit/c4b81bae563ef060860cc7e2279f8508e6d82c93))

## [1.30.3](https://github.com/snowdreamtech/nginx/compare/alpine-v1.30.3...alpine-v1.30.3) (2026-06-26)


### 🐛 Bug Fixes

* **docker:** add github proxy for acme.sh download ([b6da36c](https://github.com/snowdreamtech/nginx/commit/b6da36c605ddf46b305856fc3a0d678714028966))
* **docker:** remove hardcoded email address from acme.sh installation ([6e7dfac](https://github.com/snowdreamtech/nginx/commit/6e7dfac366bc96e30036499391e98158c68f5334))
* **docker:** start cron daemon in entrypoint for acme.sh auto-renewal ([aa0e26a](https://github.com/snowdreamtech/nginx/commit/aa0e26a898e6528ccf056cf795e42cf1cd7e3f53))
* **docker:** update acme.sh to 3.1.3 ([8b41a2d](https://github.com/snowdreamtech/nginx/commit/8b41a2d01ec6433b2c10aa4df456d4c5ca7a20c4))

## [1.30.2](https://github.com/snowdreamtech/nginx/compare/alpine-v1.30.2...alpine-v1.30.2) (2026-06-22)


### 🚀 Features

* **docker:** configure Dockerfiles for nginx variants ([d061a81](https://github.com/snowdreamtech/nginx/commit/d061a81b25ed5ff3799d1dd179ee73dd32e3aa71))
* **nginx:** import core configurations and entrypoint scripts ([ab249da](https://github.com/snowdreamtech/nginx/commit/ab249da773c088d10e22b8fceca7e07c0e26ca33))


### 🐛 Bug Fixes

* **alpine:** add empty line to trigger release pipeline test ([6f32fb1](https://github.com/snowdreamtech/nginx/commit/6f32fb1c9fae9bcd4e86beb2e3013a0138784372))
* **docker:** align nginx package versions with upstream repositories ([482ba40](https://github.com/snowdreamtech/nginx/commit/482ba405bf2ff0e33a3c25b441893a09235908f3))


### 🛠 Refactoring

* **docker:** align Dockerfiles with base image structure ([232574f](https://github.com/snowdreamtech/nginx/commit/232574fed8418f8c7f257d001e951361dfa467a0))
* remove redundant docker-entrypoint.sh files ([87c576b](https://github.com/snowdreamtech/nginx/commit/87c576b27731ad11c5bc0ebc661e07c5a09ff1c1))
* reorganize distribution variants into docker directory ([67a8c91](https://github.com/snowdreamtech/nginx/commit/67a8c911e21801bf12b3e83d02e22f3b3f59a2ba))


### 📖 Documentation

* add detailed comments to entrypoint initialization scripts ([f42cbaa](https://github.com/snowdreamtech/nginx/commit/f42cbaab6edfbc5c38c2a636dfd8651fea900940))


### ♻️ Miscellaneous Chores

* clear previous changelog entries ([5eb338a](https://github.com/snowdreamtech/nginx/commit/5eb338a0dbceff2abbdad5a867e6d53e3ef37806))
* **deps:** bump base images to alpine 3.24.0, debian 13.5.0, rocky 10.2.0 ([1688969](https://github.com/snowdreamtech/nginx/commit/168896956d2f4c7f91309c4c98ffef36ca7e8546))
* release main ([deb8454](https://github.com/snowdreamtech/nginx/commit/deb8454df7518d56939ab3851245a4cd7b03d709))
* release main ([d87cb81](https://github.com/snowdreamtech/nginx/commit/d87cb815685ad9b5b43d4b9a195c68dee2fd8065))
* release main ([78328d2](https://github.com/snowdreamtech/nginx/commit/78328d20bd3697d48ea90aee8d0eaa6af4ccc09c))
* release main ([b720ad5](https://github.com/snowdreamtech/nginx/commit/b720ad57dd1691d8ae07dcac7d46d0bd257af3a0))
* release main ([32dd84d](https://github.com/snowdreamtech/nginx/commit/32dd84de4be973395d0867b5d527d528948a35df))
* release main ([725c69f](https://github.com/snowdreamtech/nginx/commit/725c69fdcc222b5b83d0690629ce213a68c586ab))
* release main ([070b694](https://github.com/snowdreamtech/nginx/commit/070b694a702763b60fc6b057a81418320418cafa))
* release main ([36d1211](https://github.com/snowdreamtech/nginx/commit/36d1211036847a8c6aaa01a21a1c695a47b71d45))
* release main ([9ad4f94](https://github.com/snowdreamtech/nginx/commit/9ad4f9490832efdc310f2ebbd8c77f3404daf07f))
* release main ([b0684a3](https://github.com/snowdreamtech/nginx/commit/b0684a32a652e83506451e6056168cfec8b9142c))
* release main ([495e18a](https://github.com/snowdreamtech/nginx/commit/495e18a4babcb06a12c2f5aec9ea571d97cb32e3))
* release main ([d4a3a34](https://github.com/snowdreamtech/nginx/commit/d4a3a34b00a6b9f381cd5d556749c257516b2f08))
* release main ([28d9426](https://github.com/snowdreamtech/nginx/commit/28d94263f4374017274707faef7183917b689be9))
* **release:** deduplicate CHANGELOG headers ([d47fb44](https://github.com/snowdreamtech/nginx/commit/d47fb44cb105b368722d7d0e210a27b525f82d87))
* **release:** deduplicate CHANGELOG headers ([e795177](https://github.com/snowdreamtech/nginx/commit/e79517795d98b9f8292ef956586a6dc03932d03c))
* **release:** deduplicate CHANGELOG headers ([27919e4](https://github.com/snowdreamtech/nginx/commit/27919e4baf4aab5b2a2bf32a7d437b05a717c11b))
* **release:** deduplicate CHANGELOG headers ([438190d](https://github.com/snowdreamtech/nginx/commit/438190d297c151c75eca4912fdc22c285d5ec1ea))
* **release:** deduplicate CHANGELOG headers ([256f043](https://github.com/snowdreamtech/nginx/commit/256f04311b2344f2648ca5bcf407146f8c690258))
* **release:** deduplicate CHANGELOG headers ([d263aae](https://github.com/snowdreamtech/nginx/commit/d263aae7b223103a01dd0e114430381c5d863dd7))
* **release:** deduplicate CHANGELOG headers ([133954e](https://github.com/snowdreamtech/nginx/commit/133954e95cfae85cbba2fb9c1ac5acbc677ca39d))
* **release:** deduplicate CHANGELOG headers ([1d82410](https://github.com/snowdreamtech/nginx/commit/1d82410d6038be22d7741f1519826f30023b0f3e))
* **release:** deduplicate CHANGELOG headers ([5e1a539](https://github.com/snowdreamtech/nginx/commit/5e1a5390319933b48d20ad993714587d826c0aa7))
* **release:** implement automatic changelog deduplication step ([282c220](https://github.com/snowdreamtech/nginx/commit/282c22081e1ad7a1a010a7f297d20bc7c9b416a7))

## Changelog
