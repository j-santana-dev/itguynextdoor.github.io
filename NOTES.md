# HOW TO USE

## creating new empty site
```shell
make docker-new-site
```

## adding hugo theme
Example:
```shell
HUGO_THEME_GIT_REPO=https://github.com/apvarun/blist-hugo-theme.git
HUGO_THEME_NAME=blist

cd site
git submodule add ${HUGO_THEME_GIT_REPO} themes/${HUGO_THEME_NAME}
```

Don't forget to add the theme name to the `config.toml` file like the following:
```toml
baseURL = 'http://example.org/'
languageCode = 'en-us'
title = 'My New Hugo Site'
theme = "blist"
```

## add a post
```shell
make docker-add-post
```
Edit the post and set `draft: false` to publish it.


## building pages
```shell
make docker-build-pages
```

## running site on local
```shell
make compose-up
```

## compose down
```shell
make compose-down
```

## NOTES
This uses the [Blist template](https://jamstackthemes.dev/demo/theme/hugo-blist/)