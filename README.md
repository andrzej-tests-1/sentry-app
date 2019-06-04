# Sentry application main repository

Included:
* source code of sentry application
* script to build docker image and deploy it to GCR (```bin/build.sh```)
* script to deploy sentry application (based on GCR built docker image) to GKE (```bin/deploy.sh```)

### If you want to configure build&deploy environment

If you want to prepare infratructure (GCE, GKE) for this project you can go to ```terraform-repo``` and go follow the ```README.md``` file.
If you want to prepare jenkins host for this project you can go to ```ansible-repo``` and go follow the ```README.md``` file.

If you already have infrastructure and jenkins host prepared, you can start within below needs:

* install docker software (````https://docs.docker.com/install/linux/docker-ce/ubuntu/``)
* be sure that your local user is in the docker group
* install gcp software (```https://cloud.google.com/sdk/docs/quickstart-linux``` into ```/var/lib/jenkins/google-cloud-sdk```)
* install ```docker-credential-gcr``` gcp software component (```gcloud components install docker-credential-gcr```
* be sure your docker local instance has access to GCR (```$ gcloud auth configure-docker```)
* configure docker access to GCR on jenkins machine (you can use account within storage.admin role) (```docker login -u _json_key -p "$(cat ~/json-gcr-admin.json)" https://eu.gcr.io```)
* be sure that ```tiller``` package is pushed to k8s within proper ServiceAccount (```snap install helm --classic``` , ```kubectl create -f sentry-app/helm-sentry/rbac.yaml``` , ```helm init --service-account tiller```)


### If you want to build&deploy last sentry version

You can build new docker image (from last commited version of andrzej-test-1 branch) and push it to GCR repositories by run:

```
$ bin/build.sh
```

You can deploy sentry application from GCR image to GKE by run:

```
$ bin/deploy.sh
```

In the end of this script you will get information how to connect to new instance of Sentry application.

### If you want to build&deploy some specific sentry version

You can build new docker image within any commit (you have to use sha to do that) e.g. by run:

```
$ bin/build.sh 21e0e659a8a3a91641e99b67022c5d436ac183c3
```

and then push it in similary way:


```
$ bin/deploy.sh 21e0e659a8a3a91641e99b67022c5d436ac183c3
```
