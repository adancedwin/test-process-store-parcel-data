Proposed database structure can be found [here](https://github.com/adancedwin/test-process-store-parcel-data/blob/master/db/schema.rb).

# Setup
### 1. Versions
Make sure you have the latest stable ruby version which is currently for this project - 2.7.0

### 2. Bundle up
Go to the project's directory in your command line `bundle install` or simply `bundle`.

# Launch the project
### 1. Database setup
Find `database.yml.sample` and configure your own `database.yml` out of it.

Then run:
```
bundle exec rails db:create && bundle exec rails db:migrate
```

### 2. Launch the app
Launch Rails app:
```
bundle exec rails s
```


# How to use the app
First you need to put a valid XML file(s) into `<root_path_to_app>/files_to_process`. Then go to something like `http://localhost:3000/` and click the only link there. As it's done it will show you the status message in browser. After successful processing all files are put into `<root_path_to_app>/files_to_process/processed` directory.

# Tests
You can run a few tests
```
bundle exec rspec
```  