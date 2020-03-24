# Rails Engine README

Rails Engine is an API developed by [Elom Amouzou](https://github.com/eamouzou) for the Back-End Engineering program at [Turing School of Software & Design](https://turing.io).    


To set up this application in your computer; follow the given steps outlined below in your terminal:    

- Clone this repository by using the command ``` git clone git@github.com:eamouzou/rails-engine.git```    

- Find your way to the rails_engine directory ``` cd rails_engine ```

- Install the gems include in the Gemfile ``` bundle ```

- Setup the database and import data from csv files in db folder:   
 ```
 rails db:drop , rails db:{create,migrate,seed}, rake import_csv_files
 ```   

- Enjoy
