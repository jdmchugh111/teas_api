# README

## Intro

This is the repository for the tea subscription Mod 4 take home challenge. Below is the documentation for the endpoints and setup.

## Database Schema
<img width="885" alt="Screenshot 2024-08-19 at 12 13 03 AM" src="https://github.com/user-attachments/assets/87f7a62c-a856-44ac-87ab-1de521c566d2">

<br>

## Setup and Testing
- (Fork) and Clone this repo
- run `bundle install`
- run `rails db:{drop,create,migrate}`
- to use endpoints in development enivronment (through Postman or some other tool), run `rails s` and use `http://localhost:3000` as your base url
- for the test suite, run `bundle exec rspec`

## API Endpoints

### POST /api/v1/subscriptions?customer={customer's email address}&subscription={subscription title}

Subscribes a customer to a tea subscription
<br><br>
**Example Request:**
```
http://localhost:3000/api/v1/subscriptions?customer=paulina@example.com&subscription=Green Tea Monthly
```
**Example Response:**
```
{
    "data": {
        "id": "2",
        "type": "customer",
        "attributes": {
            "first_name": "Paulina",
            "last_name": "Goode",
            "email": "paulina@example.com",
            "address": "234 Main St",
            "customer_subscriptions": [
                {
                    "id": 5,
                    "customer_id": 2,
                    "subscription_id": 3,
                    "status": "active",
                    "created_at": "2024-08-19T04:16:51.306Z",
                    "updated_at": "2024-08-19T04:16:51.306Z"
                }
            ],
            "subscriptions": [
                {
                    "id": 3,
                    "title": "Green Tea Monthly",
                    "price": 19.99,
                    "frequency": "monthly",
                    "created_at": "2024-08-19T04:15:41.356Z",
                    "updated_at": "2024-08-19T04:15:41.356Z"
                }
            ]
        }
    }
}
```
### DELETE /api/v1/subscriptions/2?subscription=Green Tea Monthly

Cancels a subscription - the record of the subscription will still exist but the customer_subscription record will reflect that it has changed from "active" to "cancelled"
<br><br>
**Example Request:**
```
http://localhost:3000/api/v1/subscriptions/2?subscription=Green Tea Monthly
```
**Example Response:**
```
{
    "data": {
        "id": "2",
        "type": "customer",
        "attributes": {
            "first_name": "Paulina",
            "last_name": "Goode",
            "email": "paulina@example.com",
            "address": "234 Main St",
            "customer_subscriptions": [
                {
                    "id": 5,
                    "customer_id": 2,
                    "subscription_id": 3,
                    "status": "cancelled",
                    "created_at": "2024-08-19T04:16:51.306Z",
                    "updated_at": "2024-08-19T04:18:08.464Z"
                }
            ],
            "subscriptions": [
                {
                    "id": 3,
                    "title": "Green Tea Monthly",
                    "price": 19.99,
                    "frequency": "monthly",
                    "created_at": "2024-08-19T04:15:41.356Z",
                    "updated_at": "2024-08-19T04:15:41.356Z"
                }
            ]
        }
    }
}
```
### GET /api/v1/subscriptions?customer=raymond@example.com

Returns all subscriptions (active and cancelled) linked with a customer's account
<br><br>
**Example Request:**
```
http://localhost:3000/api/v1/subscriptions?customer=raymond@example.com
```
**Example Response:**
```
{
    "data": {
        "id": "4",
        "type": "customer",
        "attributes": {
            "first_name": "Raymond",
            "last_name": "Atwater",
            "email": "raymond@example.com",
            "address": "345 Main St",
            "customer_subscriptions": [
                {
                    "id": 3,
                    "customer_id": 4,
                    "subscription_id": 2,
                    "status": "active",
                    "created_at": "2024-08-19T04:15:41.391Z",
                    "updated_at": "2024-08-19T04:15:41.391Z"
                },
                {
                    "id": 4,
                    "customer_id": 4,
                    "subscription_id": 3,
                    "status": "active",
                    "created_at": "2024-08-19T04:15:41.393Z",
                    "updated_at": "2024-08-19T04:15:41.393Z"
                }
            ],
            "subscriptions": [
                {
                    "id": 2,
                    "title": "Black Tea Weekly",
                    "price": 7.5,
                    "frequency": "weekly",
                    "created_at": "2024-08-19T04:15:41.354Z",
                    "updated_at": "2024-08-19T04:15:41.354Z"
                },
                {
                    "id": 3,
                    "title": "Green Tea Monthly",
                    "price": 19.99,
                    "frequency": "monthly",
                    "created_at": "2024-08-19T04:15:41.356Z",
                    "updated_at": "2024-08-19T04:15:41.356Z"
                }
            ]
        }
    }
}
```
