# README

## Dependencies

- Ruby 3.3.0
- Rails 7.1.3.4
- PostgreSQL 14.11

## Installation
Clone the repository and run the next commands:

```
bundle install
```
### Config DB
Now create `.env` file and copy the ENV vars with your DB values based on [.env.example](.env.example) file
```
DATABASE=database-name
DATABASE_USER=your-sa-name
DATABASE_PASS=your-sa-password
DATABASE_PORT=5432
DATABASE_HOST=localhost
```
After config was done, run: 
```
rails db:setup
```
```
rails db:seed
```
#### Optional:
To check the code coverage: run the command or click [Image](app/assets/images/coverage.png).
```
rspec
```
### Init the app:
To login, use the default user, you can found it in [seeds.rb](db/seeds.rb) file
```
rails s
```
User:
```
example@email.com
```
Password:
```
Password123?
```
