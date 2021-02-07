FROM golang:1.14-alpine as builder
ENV CGO_ENABLED=0
WORKDIR /build
COPY . .
RUN go test
RUN go build -o /main


FROM alpine:3.13
COPY --from=builder /main /main
# (Optional) Add Lambda Runtime Interface Emulator and use a script in the ENTRYPOINT for simpler local runs
RUN wget https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/v1.0/download/aws-lambda-rie -O /usr/bin/aws-lambda-rie
RUN chmod 755 /usr/bin/aws-lambda-rie
COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ] 
CMD ['/main"]

