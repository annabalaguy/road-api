# Regions
MULTI_REGION=eu.gcr.io
REGION=europe-west1
PROJECT_ID=wabon-bootcamp

DOCKER_IMAGE_NAME=api-road
BUILD_NAME = ${MULTI_REGION}/${PROJECT_ID}/${DOCKER_IMAGE_NAME}

local_run_api:
	uvicorn api.fast:app --reload --host localhost --port 8000

dok_build_api:
	docker build -t ${BUILD_NAME} . -f ./Dockerfile

dok_run_api:
	docker run -e PORT=8080 -p 8000:8080 ${BUILD_NAME}

dok_push_gcp:
	docker push ${BUILD_NAME}

gcp_run_deploy:
	gcloud run deploy --image ${BUILD_NAME} \
                	  --platform managed \
                	  --region ${REGION}


# ----------------------------------
#          INSTALL & TEST
# ----------------------------------
install_requirements:
	@pip install -r requirements.txt

check_code:
	@flake8 scripts/* road_detector/*.py

black:
	@black scripts/* road_detector/*.py

test:
	@coverage run -m pytest tests/*.py
	@coverage report -m --omit="${VIRTUAL_ENV}/lib/python*"

ftest:
	@Write me

clean:
	@rm -f */version.txt
	@rm -f .coverage
	@rm -fr */__pycache__ */*.pyc __pycache__
	@rm -fr build dist
	@rm -fr road_detector-*.dist-info
	@rm -fr road_detector.egg-info

install:
	@pip install . -U

all: clean install test black check_code

count_lines:
	@find ./ -name '*.py' -exec  wc -l {} \; | sort -n| awk \
        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''
	@find ./scripts -name '*-*' -exec  wc -l {} \; | sort -n| awk \
		        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''
	@find ./tests -name '*.py' -exec  wc -l {} \; | sort -n| awk \
        '{printf "%4s %s\n", $$1, $$2}{s+=$$0}END{print s}'
	@echo ''


# ----------------------------------
#         API COMMANDS
# ----------------------------------
run_api:
	uvicorn api.fast:app --reload
