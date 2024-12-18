# Receipt Processor API - Instructions

This guide will walk you through the setup of the Receipt Processor API. Including building a Docker container, running the server, and using Git Bash to interact with the API.

## Requirements

Make sure you have the following installed:
- **Git Bash**: [Download Git](https://git-scm.com/downloads)
- **Docker**: [Install Docker](https://www.docker.com/get-started/)
- **Go**: [Install Go](https://golang.org/doc/install)

## Project Setup

## 1. Clone the Repo

Start with cloning the repo with Git Bash

```bash
git clone https://github.com/qbendelsmith/receipt-processor-challenge.git
cd receipt-processor-challenge
```

## 2. Build Docker Image
In order to run the project, you have to build a docker image. Run the following command from the project's root directory in Git Bash

```bash
docker build -t receipt-processor .
```

This builds the docker image using Dockerfile in the directory with the name receipt-processor.

## 3. Run the Docker Container
Once the image is built, you can now run the container, which starts the API server on port 8080.

```bash
docker run -d -p 8080:8080 receipt-processor
```

I found that running in detached mode with -d was the easiest method. -p maps the port and receipt processor gives it a name.

## Playing with the API

With the server running, you can now use curl with Git Bash to interact with the API, alternatively you can use tools like Postman if available, but I will instruct you on how to use Git Bash.

## 1. Adding Receipts (POST /receipts/process)

You can add receipts by sending POST requests to the /receipts/process endpoint. Here is an example of how to do so with curl in Git Bash

```bash
curl -X POST http://localhost:8080/receipts/process -d '{
  "retailer": "M&M Corner Market",
  "purchaseDate": "2022-03-20",
  "purchaseTime": "14:33",
  "items": [
    {
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    },{
      "shortDescription": "Gatorade",
      "price": "2.25"
    }
  ],
  "total": "9.00"
}' -H "Content-Type: application/json"
```

This will return a JSON response with the unique uuid generated for the receipt. In this example I got:

```bash
{"id":"fdfa4716-c22f-4c58-9a7a-50d693e936fd"}
```

Copy this id in order to run GET request later.

## 2. Getting Points for Receipt (GET /receipts/{id}/points)
After adding a receipt, you can now calculate and get the point value of that specific receipt. To do so, run the following in Git Bash using the example above:

```bash
curl http://localhost:8080/receipts/fdfa4716-c22f-4c58-9a7a-50d693e936fd/points
```

The returned value should look like this:

```bash
{"points":109}
```

## Stop Running the Container
To stop running the container, run the following:

```bash
docker stop $(docker ps -q)
```

Due to time constraints, I do not have the ability to create extensive testing, I have done testing with the examples and some edge cases to ensure everything works as intended.
