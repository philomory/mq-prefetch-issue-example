FROM ruby:3

COPY Gemfile ./
RUN bundle install
COPY . .

