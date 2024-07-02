README
====================================================================================================

Motivation
----------------------------------------------------------------------------------------------------

Did you hear about [Ruby Certification](https://www.ruby.or.jp/en/certification/examination/)? I found out about it through a Bookmate vacancy. The Ruby Association even published a list of questions for self-preparation.

So, I went through both the silver and gold preparing lists and figured out that this process is not so enjoyable. I'm afraid many people will prefer to skip it. You need to write answers, then check and count the results manually. It's boring (sometimes they ask you to "choose two" for questions with only one correct variant).

That's exactly why I created a simple Rails app that anybody can run locally. I hope it will help lazy people like me to answer the questions and check the results, even if they don't want to spend $150.

P.S. I've added so many strange tests and I still think it's even less than needed. I imagine using this app to test different approaches (Rom, view-components, React, Hotwire) in the future, since it's a simple app (7 models!) but useful at the same time. For the same reason I didn't fix some issues since I want to compare solutions.

P.P.S. My score is 80% for silver and 76% for gold (seriously, who will remember all `Dir/Time` methods?)

<img width="1445" alt="image" src="https://github.com/Krugloff/prep_test/assets/1621036/a42ebd7a-0595-4b6f-9926-971091276281">

Installation
----------------------------------------------------------------------------------------------------

This is a very simple rails app so there are a few steps only.

+ clone the repository to your local machine
+ run `bundle exec bundle` to install all required gems
+ run `bundle exec rake db:migrate`  to initialize the SQLite3 database.
+ run `bundle exec rake:seed` to load silver and gold preparing question's lists into the database.
+ run `bundle exec rails s` to start the server
+ open a browser and visit something like `0.0.0.0:3000`
+ You should see the next steps on your screen

Gems
----------------------------------------------------------------------------------------------------

I added only the `redcarpet` for markdown parsing and `factory_bot_rails` for testing to the initial Rails Gemfile.
