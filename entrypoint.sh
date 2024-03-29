#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi

if [ -z "$INPUT_DESTINATION_BRANCH" ]
then
  INPUT_DESTINATION_BRANCH=master
fi
OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH"

if [ -z "$INPUT_COMMIT_MSG" ]
then
  INPUT_COMMIT_MSG="Update $INPUT_DESTINATION_FOLDER."
fi

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
git clone --single-branch --branch $INPUT_DESTINATION_BRANCH "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"

if [ ! -z "$INPUT_DESTINATION_BRANCH_CREATE" ]
then
  git checkout -b "$INPUT_DESTINATION_BRANCH_CREATE"
  OUTPUT_BRANCH="$INPUT_DESTINATION_BRANCH_CREATE"
fi

case "$INPUT_DESTINATION_PROJECT" in
    "helix2")
        echo "helix2"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        cp $INPUT_SOURCE_FOLDER/helix2-generated.pb $CLONE_DIR/$INPUT_DESTINATION_FOLDER/helix2-generated.pb
        ;;
    "helix2-gmt")
        echo "helix2"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        ;;
    "hamster")
        echo "hamster"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        cp $INPUT_SOURCE_FOLDER/hamster-generated.pb $CLONE_DIR/$INPUT_DESTINATION_FOLDER/hamster-generated.pb
        ;;
    "hamster-gmt")
        echo "hamster"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        ;;
    "illidan-dashboard")
        echo "illidan-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        cp $INPUT_SOURCE_EXTENSION_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/$INPUT_SOURCE_EXTENSION_TARGET_FILENAME.proto
        ;;
    "illidan-api")
        echo "illidan-api"
        cp $INPUT_SOURCE_FOLDER/chat/worker/apis/client-go/request/request.go $CLONE_DIR/pkg/chat/worker/apis/client-go/request/request.go
        sed -i 's/nevercase\/lllidan/Shanghai-Lunara\/illidan-api/g' $CLONE_DIR/pkg/chat/worker/apis/client-go/request/request.go
        sed -i 's/*Client/*k8sresolver.Client/g' $CLONE_DIR/pkg/chat/worker/apis/client-go/request/request.go
        sed -i 's/apis\/proto\"/apis\/proto\"\n\tk8sresolver \"github.com\/nevercase\/grpc-k8s-resolver\/pkg\/request\"/g' $CLONE_DIR/pkg/chat/worker/apis/client-go/request/request.go
        cp $INPUT_SOURCE_FOLDER/chat/worker/apis/client-go/request/const.go $CLONE_DIR/pkg/chat/worker/apis/client-go/request/const.go
        cp $INPUT_SOURCE_FOLDER/chat/worker/apis/proto/api.proto $CLONE_DIR/pkg/chat/worker/apis/proto/api.proto
        ;;
    "guldan-dashboard")
        echo "guldan-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/generated.proto
        cp $INPUT_SOURCE_EXTENSION_FOLDER/guldan/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/$INPUT_SOURCE_EXTENSION_TARGET_FILENAME.proto
        cp $INPUT_SOURCE_EXTENSION_FOLDER/rbac/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.apis.meta.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.apis.meta.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.schema.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.schema.proto
        ;;
    "discovery-dashboard")
        echo "discovery-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.aggregator.proto.proto
        cp ./pkg/apis/aliyun/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.aliyun.v1.proto
        cp ./pkg/apis/apps/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.apps.v1.proto
        cp ./pkg/apis/hamster/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.hamster.v1.proto
        cp ./pkg/apis/helix2/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.helix2.v1.proto
        cp ./pkg/apis/rbac/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto
        cp ./pkg/apis/storage/v1/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.storage.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.apis.meta.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.apis.meta.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.schema.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.schema.proto
        ;;
    "sargeras-dashboard")
        echo "sargeras-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.sargeras.pkg.aggregator.proto.proto
        cp $INPUT_SOURCE_EXTENSION_FOLDER/sargeras/v2/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/$INPUT_SOURCE_EXTENSION_TARGET_FILENAME.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.apis.meta.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.apis.meta.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.schema.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.schema.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.api.apps.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.api.apps.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.api.core.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.api.core.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.api.rbac.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.api.rbac.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.api.autoscaling.v2.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.api.autoscaling.v2.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.api.resource.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.api.resource.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.util.intstr.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.util.intstr.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.metrics.pkg.apis.metrics.v1beta1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.metrics.pkg.apis.metrics.v1beta1.proto
        cp ./pkg/kubernetes/apimachinery/github.com.nevercase.discovery.pkg.apis.guldan.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.guldan.v1.proto
        cp ./pkg/kubernetes/apimachinery/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto
        ;;
    "cdn-proxy-dashboard")
        echo "cdn-proxy-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp $INPUT_SOURCE_FOLDER/generated.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.cdn_proxy.pkg.proto.proto
        cp ./pkg/kubernetes/apimachinery/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/github.com.nevercase.discovery.pkg.apis.rbac.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.apis.meta.v1.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.apis.meta.v1.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.proto
        cp ./pkg/kubernetes/apimachinery/k8s.io.apimachinery.pkg.runtime.schema.proto $CLONE_DIR/$INPUT_DESTINATION_FOLDER/k8s.io.apimachinery.pkg.runtime.schema.proto
        ;;
    "Scheduler")
        echo "cdn-Scheduler-dashboard"
        mkdir -p $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        cp -r $INPUT_SOURCE_FOLDER/ $CLONE_DIR/$INPUT_DESTINATION_FOLDER/
        ;;
    *)
        echo "Hadn't specified the env INPUT_DESTINATION_PROJECT"
        ;;
esac

cd "$CLONE_DIR"

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "$INPUT_COMMIT_MSG"
  echo "Pushing git commit"
  git push -u origin HEAD:$OUTPUT_BRANCH
else
  echo "No changes detected"
fi