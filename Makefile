.PHONY: install lint build deploy publish destroy test terraform clean
PROJECT            := helix-unreal
PROJECT_CODE       := hu
TF_VER             := 1.0.5
TF_STATE           := steel-pinion-tfstate-${ENV}
TF_STATEFILE_REGION:= us-east-1
BUILD_LOCAL_DIR    := .build
OS                 := $(shell uname | tr '[:upper:]' '[:lower:]')
ROOT_DIR           := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# 
# Common Repositry Activities
# 

install:
	@make -s terraform 

lint:
	@${BUILD_LOCAL_DIR}/terraform fmt -recursive

build:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform init \
		-backend-config="bucket=${TF_STATE}" \
		-backend-config="key=${PROJECT}/${TARGET}/terraform.tfstate" \
		-backend-config="region=${TF_STATEFILE_REGION}" \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform get \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform validate

deploy:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform apply ${AUTO_APPROVE} \
		-var="project=${PROJECT}" \
		-var="project_code=${PROJECT_CODE}" \
		-var="environment=${ENV}"

publish:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform apply ${AUTO_APPROVE} \
		-var="project=${PROJECT}" \
		-var="project_code=${PROJECT_CODE}" \
		-var="environment=${ENV}" \
		-var="is_publish=true"

destroy:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform destroy \
		-var="project=${PROJECT}" \
		-var="project_code=${PROJECT_CODE}" \
		-var="environment=${ENV}"

forget:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform state list \
	&& echo "UNTRACKING ENTITY STATE: ${ENTITY}" \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform state rm ${ENTITY}

import:
	@. ./config/secrets-${ENV}.env \
	&& cd ./infra/${TARGET} \
	&& echo "IMPORT ENTITY STATE: ${ENTITY}" \
	&& ${ROOT_DIR}/${BUILD_LOCAL_DIR}/terraform import ${ENTITY} ${ID}

terraform:
ifeq ($(OS), darwin)
	@curl https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_${OS}_arm64.zip --output ./terraform.zip > /dev/null 2>&1
else
	@curl https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_${OS}_amd64.zip --output ./terraform.zip > /dev/null 2>&1
endif
	@unzip ./terraform.zip -d . \
	&& rm -f ./terraform.zip \
	&& chmod +x ./terraform \
	&& mkdir -p ${BUILD_LOCAL_DIR} \
	&& mv ./terraform ${BUILD_LOCAL_DIR}/terraform

prepare:
	@mkdir -p  ./config/ \
	&& touch ./config/secrets-${ENV}.env \
	&& make install \
	&& aws s3api create-bucket --bucket ${TF_STATE} --region ${TF_REGION} --create-bucket-configuration LocationConstraint=${TF_REGION} || true

clean:
	@rm -rf ${BUILD_LAYER_DIR} ;
ifeq ($(OS), darwin)
	@find ${BUILD_LOCAL_DIR} \! -name 'terraform' -delete;
else
	@find ${BUILD_LOCAL_DIR}/* \! -name 'terraform' -delete;
endif
