#!/usr/bin/env bash

apps=(
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
)

for i in "${apps[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "github.com/${i}"
done
