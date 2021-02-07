FROM golang:1.6rc1-alpine as builder
ENV CGO_ENABLED=0
COPY . .
RUN go test
RUN go build -o /app

ARG LAMBDA_TASK_ROOT=/var/task
FROM public.ecr.aws/lambda/go:1

# Copy function code
COPY --from=builder /app ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app" ]
