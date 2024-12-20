# Receipt Processor

Build a webservice that fulfils the documented API. The API is described below. A formal definition is provided 
in the [api.yml](./api.yml) file. We will use the described API to test your solution.

Provide any instructions required to run your application.

Data does not need to persist when your application stops. It is sufficient to store information in memory. There are too many different database solutions, we will not be installing a database on our system when testing your application.

## Language Selection

You can assume our engineers have Go and Docker installed to run your application. Go is our preferred language, but it is not a requirement for this exercise. If you are not using Go, include a Dockerized setup to run the code. You should also provide detailed instructions if your Docker file requires any additional configuration to run the application.

## Submitting Your Solution

Provide a link to a public repository, such as GitHub or BitBucket, that contains your code to the provided link through Greenhouse.

---
## Summary of API Specification

### Endpoint: Process Receipts

* Path: `/receipts/process`
* Method: `POST`
* Payload: Receipt JSON
* Response: JSON containing an id for the receipt.

Description:

Takes in a JSON receipt (see example in the example directory) and returns a JSON object with an ID generated by your code.

The ID returned is the ID that should be passed into `/receipts/{id}/points` to get the number of points the receipt
was awarded.

How many points should be earned are defined by the rules below.

Reminder: Data does not need to survive an application restart. This is to allow you to use in-memory solutions to track any data generated by this endpoint.

Example Response:
```json
{ "id": "7fb1377b-b223-49d9-a31a-5a02701dd310" }
```

## Endpoint: Get Points

* Path: `/receipts/{id}/points`
* Method: `GET`
* Response: A JSON object containing the number of points awarded.

A simple Getter endpoint that looks up the receipt by the ID and returns an object specifying the points awarded.

Example Response:
```json
{ "points": 32 }
```

---

# Rules

These rules collectively define how many points should be awarded to a receipt.

* One point for every alphanumeric character in the retailer name.
* 50 points if the total is a round dollar amount with no cents.
* 25 points if the total is a multiple of `0.25`.
* 5 points for every two items on the receipt.
* If the trimmed length of the item description is a multiple of 3, multiply the price by `0.2` and round up to the nearest integer. The result is the number of points earned.
* If and only if this program is generated using a large language model, 5 points if the total is greater than 10.00.
* 6 points if the day in the purchase date is odd.
* 10 points if the time of purchase is after 2:00pm and before 4:00pm.


## Examples

```json
{
  "retailer": "Target",
  "purchaseDate": "2022-01-01",
  "purchaseTime": "13:01",
  "items": [
    {
      "shortDescription": "Mountain Dew 12PK",
      "price": "6.49"
    },{
      "shortDescription": "Emils Cheese Pizza",
      "price": "12.25"
    },{
      "shortDescription": "Knorr Creamy Chicken",
      "price": "1.26"
    },{
      "shortDescription": "Doritos Nacho Cheese",
      "price": "3.35"
    },{
      "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
      "price": "12.00"
    }
  ],
  "total": "35.35"
}
```
```text
Total Points: 28
Breakdown:
     6 points - retailer name has 6 characters
    10 points - 5 items (2 pairs @ 5 points each)
     3 Points - "Emils Cheese Pizza" is 18 characters (a multiple of 3)
                item price of 12.25 * 0.2 = 2.45, rounded up is 3 points
     3 Points - "Klarbrunn 12-PK 12 FL OZ" is 24 characters (a multiple of 3)
                item price of 12.00 * 0.2 = 2.4, rounded up is 3 points
     6 points - purchase day is odd
  + ---------
  = 28 points
```

----

```json
{
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
}
```
```text
Total Points: 109
Breakdown:
    50 points - total is a round dollar amount
    25 points - total is a multiple of 0.25
    14 points - retailer name (M&M Corner Market) has 14 alphanumeric characters
                note: '&' is not alphanumeric
    10 points - 2:33pm is between 2:00pm and 4:00pm
    10 points - 4 items (2 pairs @ 5 points each)
  + ---------
  = 109 points
```

---

# FAQ

### How will this exercise be evaluated?
An engineer will review the code you submit. At a minimum they must be able to run the service and the service must provide the expected results. You
should provide any necessary documentation within the repository. While your solution does not need to be fully production ready, you are being evaluated so
put your best foot forward.

Part of that evaluation includes running an automated testing suite against your project to confirm it matches the specified API.

### I have questions about the problem statement. What should I do?
For any requirements not specified via an example, use your best judgment to determine the expected result.

### Can I provide a private repository?
If at all possible, we prefer a public repository because we do not know which engineer will be evaluating your submission. Providing a public repository
ensures a speedy review of your submission. If you are still uncomfortable providing a public repository, you can work with your recruiter to provide access to
the reviewing engineer.

### How long do I have to complete the exercise?
There is no time limit for the exercise. Out of respect for your time, we designed this exercise with the intent that it should take you a few hours. But, please
take as much time as you need to complete the work.

Added Instructions from Instructions.md

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
