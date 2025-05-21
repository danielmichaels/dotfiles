#!/usr/bin/env bash

apps=(
	# danielmichaels/gpt/cmd/gpt@latest
	# aandrew-me/tgpt@latest
	mr-karan/doggo/cmd/doggo@latest
	danielmichaels/zet-cmd/cmd/zet@latest
	charmbracelet/mods@latest
	charmbracelet/glow@latest
	air-verse/air@latest
	sqlc-dev/sqlc/cmd/sqlc@latest
	rs/curlie@latest
  pressly/goose/v3/cmd/goose@latest
	grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	grpc-ecosystem/grpc-gateway/protoc-gen-swagger@latest
	grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
	golang/protobuf/protoc-gen-go@latest
	fullstorydev/grpcurl/cmd/grpcurl@latest
	fullstorydev/grpcui/cmd/grpcui@latest
  oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest
	a-h/templ/cmd/templ@latest
	dkorunic/betteralign/cmd/betteralign@latest
	incu6us/goimports-reviser/v3@latest
	segmentio/golines@latest
	go-delve/delve/cmd/dlv@latest
	boyter/cs@latest
  nats-io/natscli/nats@latest
  danielmiessler/yt@latest
  danielmiessler/fabric@latest
  # synadia
  atombender/go-jsonschema@latest
  volatiletech/sqlboiler/v4@v4.16.2
  volatiletech/sqlboiler/v4/drivers/sqlboiler-psql@v4.16.2
)

custom=(
	google.golang.org/protobuf/cmd/protoc-gen-go@latest
	google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	mvdan.cc/sh/v3/cmd/shfmt@latest
  mvdan.cc/gofumpt@latest
  # synadia
  cuelang.org/go/cmd/cue@latest
)
for i in "${apps[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "github.com/${i}"
done

for i in "${custom[@]}"; do
	printf "Installing: %s\n" "${i}"
	go install "${i}"
done
