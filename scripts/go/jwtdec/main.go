package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"strings"
)

func main() {
	flag.Parse()
	if len(flag.Args()) == 0 {
		log.Fatal("JWT token is required as an argument")
	}
	jwtToken := flag.Args()[0]
	parts := strings.Split(jwtToken, ".")
	if len(parts) < 2 {
		log.Fatal("Invalid JWT token")
	}
	payload := parts[1]
	jsonBytes, err := base64.RawStdEncoding.DecodeString(payload)
	if err != nil {
		log.Fatal(err)
	}

	var prettyJSON bytes.Buffer
	err = json.Indent(&prettyJSON, jsonBytes, "", "  ")
	if err != nil {
		log.Fatal("Failed to pretty-print JSON:", err)
	}

	fmt.Println(prettyJSON.String())
}
