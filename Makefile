.PHONY: ci-image
ci-image:
	gcloud builds submit --config=ci-image.yaml \
	  --substitutions=_REPOSITORY="gke-microservices-ci",_IMAGE="builder" .
