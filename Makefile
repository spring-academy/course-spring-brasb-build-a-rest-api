#!make
BUILDER ?= github
include Makefile.$(BUILDER)


build: build-date add-files-to-archive docker-lab-html

.PHONY: help build release add-files-to-archive docker-lab-html Makefile releaseclean get-reporeg get-name deploy

add-files-to-archive:
	cp -r labs/* build
	for d in build/*; do \
	  tar -czvf build/`cat $$d/.WORKSHOP_ID`.tar.gz -C $$d . || true; \
	done

	mkdir -p build/educates-resources
	cp -r resources/* build/educates-resources
	for f in build/educates-resources/apply/*; do \
	  VERSION=${version} CONTAINER_REGISTRY=${CONTAINER_REGISTRY} CONTAINER_REPOSITORY=${CONTAINER_REPOSITORY} envsubst '$${VERSION} $${CONTAINER_REGISTRY} $${CONTAINER_REPOSITORY}' < $$f > $$f.resolved; \
	  mv $$f.resolved $$f; \
	done

	git clone -b ${CODE_REPO_BRANCH} ${CODE_REPO} build/exercises
	tar -czvf build/exercises.tar.gz -C build exercises
	rm -rf build/exercises

build-date:
	rm -rf build
	# This ensures there is always a build directory with an asset to upload
	mkdir -p build

docker-lab-html:

	docker build --build-arg VERSION="${version}" --build-arg IMAGE_SOURCE="${IMAGE_SOURCE}" \
				 -t "${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}" \
				 -t "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${env}" \
				 .

	docker image prune -f

docker-lab-html-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

release:
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:latest

deploy-lab:
	docker pull ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version}
	docker tag ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${version} ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}
	docker push ${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}:${environment}

deploy-lab-local:
	kubectl apply -f build/educates-resources/apply
	source build/educates-resources/env."${environment}"
	envsubst '$${ENVIRONMENT}' < build/educates-resources/apply/trainingportal.yaml | kubectl apply -f -

deploy-lms:
	metadata/lms/deploy.sh deploy-all

get-reporeg:
	@echo "${CONTAINER_REGISTRY}${CONTAINER_REPOSITORY}"

get-name:
	@echo "${NAME}"
