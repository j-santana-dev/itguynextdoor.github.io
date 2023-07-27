PROJECT_NAME=hugo
SITE_NAME=site

new-site:
	hugo new site $(SITE_NAME)
	chown -R 1000:1000 $(SITE_NAME)

# add-post:
# 	cd $(SITE_NAME) && hugo new content/en/blog/changeme.md
# 	chown -R 1000:1000 $(SITE_NAME)

build-pages:
	cp -fv $(SITE_NAME)/themes/blist/package.json $(SITE_NAME)
	cp -fv $(SITE_NAME)/themes/blist/package-lock.json $(SITE_NAME)
	cd $(SITE_NAME) && npm install && npm i -g postcss-cli
	cd $(SITE_NAME) && hugo -D -b http://localhost
	chown -R 1000:1000 $(SITE_NAME)

compose-up:
	@docker-compose -f docker-compose.yml up

compose-down:
	@docker-compose -f docker-compose-build.yml down --remove-orphans
	@docker-compose -f docker-compose.yml down --remove-orphans

docker-%:
	@docker-compose -f docker-compose-build.yml down --remove-orphans
	@docker-compose -f docker-compose-build.yml run --rm $(PROJECT_NAME) make $*