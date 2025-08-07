# 📍 Roterize - Backend

**Roterize** is a smart assistant that helps people plan special moments — like romantic dates, friend hangouts, or meaningful time with family — by generating personalized activity itineraries based on preferences, location, budget, and time.

This repository contains the **backend API**, built with **Ruby on Rails**, using **MongoDB** as the data store.

---

## ✨ Features

- User registration and authentication (JWT)
- Create and manage custom "moments" (planned experiences)
- Personalized route generation
- Location-aware suggestions
- Store and retrieve recommended places
- Collect feedback from users to improve future suggestions

---

## 🛠 Tech Stack

- **Ruby on Rails 7**
- **MongoDB** with `mongoid`
- **JWT** for API authentication
- **RSpec** for testing
- **Dotenv-Rails** for environment configs
- **Rack-CORS** for handling cross-origin requests

---

## 🚀 Getting Started

### 1. Clone the repository

---

## 🐳 Running with Docker

### 1. Build the containers
```bash
docker-compose build --no-cache
```
### 2. Start the services
```bash
docker-compose up
```
### 3. Run Rails commands (like migrations or console)
```bash
docker exec -u root -it roterize-api-web-1 bundle exec rails <your-command>
```


