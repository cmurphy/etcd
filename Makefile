.PHONY: build
build:
	GO_BUILD_FLAGS="-v" ./scripts/build.sh
	./bin/etcd --version
	./bin/etcdctl version
	./bin/etcdutl version

# Tests

.PHONY: test
test:
	PASSES="unit integration release e2e" ./scripts/test.sh

.PHONY: test-unit
test-unit:
	PASSES="unit" ./scripts/test.sh

.PHONY: test-integration
test-integration:
	PASSES="integration" ./scripts/test.sh

.PHONY: test-e2e
test-e2e: build
	PASSES="e2e" ./scripts/test.sh

.PHONY: test-e2e-release
test-e2e-release: build
	PASSES="release e2e" ./scripts/test.sh

# Static analysis

verify: verify-gofmt verify-bom verify-lint verify-dep verify-shellcheck verify-goword verify-govet verify-revive verify-license-header verify-receiver-name verify-mod-tidy verify-shellcheck verify-shellws verify-proto-annotations
update: update-bom update-lint update-dep update-fix

.PHONY: verify-gofmt
verify-gofmt:
	PASSES="gofmt" ./scripts/test.sh

.PHONY: verify-bom
verify-bom:
	PASSES="bom" ./scripts/test.sh

.PHONY: update-bom
update-bom:
	./scripts/updatebom.sh

.PHONY: verify-dep
verify-dep:
	PASSES="dep" ./scripts/test.sh

.PHONY: update-dep
update-dep:
	./scripts/update_dep.sh

.PHONY: verify-lint
verify-lint:
	golangci-lint run

.PHONY: update-lint
update-lint:
	golangci-lint run --fix

.PHONY: update-fix
update-fix:
	./scripts/fix.sh

.PHONY: verify-shellcheck
verify-shellcheck:
	PASSES="shellcheck" ./scripts/test.sh

.PHONY: verify-goword
verify-goword:
	PASSES="goword" ./scripts/test.sh

.PHONY: verify-govet
verify-govet:
	PASSES="govet" ./scripts/test.sh

.PHONY: verify-revive
verify-revive:
	PASSES="revive" ./scripts/test.sh

.PHONY: verify-license-header
verify-license-header:
	PASSES="license_header" ./scripts/test.sh

.PHONY: verify-receiver-name
verify-receiver-name:
	PASSES="receiver_name" ./scripts/test.sh

.PHONY: verify-mod-tidy
verify-mod-tidy:
	PASSES="mod_tidy" ./scripts/test.sh

.PHONY: verify-shellws
verify-shellws:
	PASSES="shellws" ./scripts/test.sh

.PHONY: verify-proto-annotations
verify-proto-annotations:
	PASSES="proto_annotations" ./scripts/test.sh


# Cleanup

clean:
	rm -f ./codecov
	rm -rf ./covdir
	rm -f ./bin/Dockerfile-release*
	rm -rf ./bin/etcd*
	rm -rf ./default.etcd
	rm -rf ./tests/e2e/default.etcd
	rm -rf ./release
	rm -rf ./coverage/*.err ./coverage/*.out
	rm -rf ./tests/e2e/default.proxy
	find ./ -name "127.0.0.1:*" -o -name "localhost:*" -o -name "*.log" -o -name "agent-*" -o -name "*.coverprofile" -o -name "testname-proxy-*" -delete
