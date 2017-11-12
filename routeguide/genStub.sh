#!/usr/bin/env sh

# generating echo.pb.go
#       --go_out=plugins=grpc:. *.proto # With go proto

protoc --gofast_out=plugins=grpc:. *.proto

