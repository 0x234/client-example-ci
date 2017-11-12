FROM golang:alpine

MAINTAINER jakebunce@gmail.com

RUN apk update && apk add lmdb-dev git gcc musl-dev

RUN go get google.golang.org/grpc/credentials
RUN go get golang.org/x/net/context
RUN go get google.golang.org/grpc

ADD ./client /client/

ADD ./routeguide /client/routeguide/

ADD ./testdata/ /client/testdata/

RUN go build /client/client.go

CMD ["watch", "-n1", "./client", "-server_addr", "backend-service:8888"]
