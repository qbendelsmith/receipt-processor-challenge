FROM golang:1.23.4

WORKDIR /app
COPY go.mod go.sum ./

RUN go mod tidy

COPY . .

RUN go build -o main .

CMD ["/app/main"]

EXPOSE 8080