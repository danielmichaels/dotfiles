#!/usr/bin/env bash

apps=(
	mr-karan/doggo/cmd/doggo@latest
	danielmichaels/gpt/cmd/gpt@latest
	danielmichaels/ds/cmd/ds@latest
	danielmichaels/zet-cmd/cmd/zet@latest
	aandrew-me/tgpt@latest
	charmbracelet/mods@latest
	charmbracelet/glow@latest
	cosmtrek/air@latest
	sqlc-dev/sqlc/cmd/sqlc@latest
	azimjohn/jprq/cli@latest
	rs/curlie@latest
	grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	grpc-ecosystem/grpc-gateway/protoc-gen-swagger@latest
	grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	golang/protobuf/protoc-gen-go@latest
	fullstorydev/grpcurl/cmd/grpcurl@latest
	fullstorydev/grpcui/cmd/grpcui@latest
	deepmap/oapi-codegen/v2/cmd/oapi-codegen@latest
	jesseduffield/lazydocker@latest
	a-h/templ/cmd/templ@latest
	iawia002/lux@latest
	dkorunic/betteralign/cmd/betteralign@latest
	incu6us/goimports-reviser/v3@latest
	segmentio/golines@latest
	go-delve/delve/cmd/dlv@latest
	boyter/scc@master
	boyter/dcd@latest
	boyter/cs@latest
	google/yamlfmt/cmd/yamlfmt@latest
  projectdiscovery/pdtm/cmd/pdtm@latest
)

custom=(
	goa.design/goa/v3/cmd/goa@v3
	google.golang.org/protobuf/cmd/protoc-gen-go@latest
	google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	mvdan.cc/sh/v3/cmd/shfmt@latest
)
for i in "${apps[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "github.com/${i}"
done

for i in "${custom[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "${i}"
done
