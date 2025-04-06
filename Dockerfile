FROM golang:1.21-alpine AS builder # Using a more recent Alpine-based Go image

WORKDIR /app # Use a more standard working directory

COPY go.mod go.sum ./
RUN go mod download

COPY sfu/ ./pkg/ # Use relative paths
COPY cmd/ ./cmd/
COPY config.toml ./

RUN CGO_ENABLED=0 go build -o ion-sfu ./cmd/ion-sfu # Build the executable

FROM alpine:latest # Use a lightweight Alpine image for the final container

WORKDIR /app

COPY --from=builder /app/ion-sfu .
COPY config.toml ./

EXPOSE 7880 # Or the port your application uses

CMD ["./ion-sfu"]