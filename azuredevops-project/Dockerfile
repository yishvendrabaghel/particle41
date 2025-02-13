FROM golang:1.23-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o SimpleTimeService

FROM gcr.io/distroless/static-debian12
WORKDIR /app
COPY --from=builder /app/SimpleTimeService .
USER nonroot
CMD ["/app/SimpleTimeService"]
EXPOSE 8080
