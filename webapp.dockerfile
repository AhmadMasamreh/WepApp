FROM ruby:2.5
EXPOSE 80
COPY webapp.rb .
CMD ruby webapp.rb
