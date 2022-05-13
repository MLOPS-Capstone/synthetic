include .env

build:
	pip freeze > requirements.txt
	docker build . -t $(IMAGE_REPOSITORY)/$(IMAGE_NAME)

run:
start:
	docker-compose up -d --build
	docker-compose logs -f --tail=20

stop:
	docker-compose down

bash:
	docker run -it $(IMAGE_REPOSITORY)/$(IMAGE_NAME) /bin/bash

logs:
	docker-compose logs -f service

deploy:
	time=$$(date +'%Y%m%d-%H%M%S') && \
	docker tag $(IMAGE_REPOSITORY)/$(IMAGE_NAME) us-east1-docker.pkg.dev/mlops-3/capstone-tradingbot/$(IMAGE_NAME):$$time && \
	docker push us-east1-docker.pkg.dev/mlops-3/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):$$time && \
	kubectl set image deployment $(IMAGE_NAME) $(IMAGE_NAME)=us-east1-docker.pkg.dev/mlops-3/$(IMAGE_REPOSITORY)/$(IMAGE_NAME):$$time

auth:
	gcloud -q components update
	gcloud auth login
	gcloud -q config set project mlops-3
	gcloud -q auth configure-docker us-east1-docker.pkg.dev
