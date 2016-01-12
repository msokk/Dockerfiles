FROM alpine:3.3

ENV DEV_PACKAGES="build-base postgresql-dev libxml2-dev libxslt-dev ruby-dev" \
    PACKAGES="ca-certificates nodejs tzdata libpq libxml2 libxslt" \
    RUBY_PACKAGES="ruby ruby-bigdecimal ruby-io-console ruby-json ruby-irb" \

    # Set Rails to run in production
    RAILS_ENV=production RACK_ENV=production

# Skip installing gem documentation
RUN echo "gem: --no-rdoc --no-ri" >> "$HOME/.gemrc" && \
    # Prepare app folder
    mkdir -p /app && \

    # Install packages and remove RI documentation
    apk --no-cache add --virtual build-dependencies $DEV_PACKAGES && \
    apk --no-cache add $PACKAGES $RUBY_PACKAGES && \

    # Install bundler
    gem install bundler && \

    # Throw errors if Gemfile has been modified since Gemfile.lock
    bundle config --global frozen 1 && \

    # Silence root error
    bundle config --global silence_root_warning 1 && \
    
    # Skip development and test gems
    bundle config --global without "development:test" && \
    bundle config --global build.nokogiri  "--use-system-libraries" && \
    rm -rf /usr/lib/ruby/gems/*/cache/*


# Install production gems using cache
ONBUILD COPY Gemfile* /tmp/
ONBUILD WORKDIR /tmp
ONBUILD RUN bundle install && rm -rf /usr/lib/ruby/gems/*/cache/*

# Clean up build system
ONBUILD RUN apk del build-dependencies

ONBUILD WORKDIR /app

# Copy the main application.
ONBUILD COPY . ./

# Precompile assets
ONBUILD RUN bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec"]
CMD ["rails", "server", "-b", "0.0.0.0"]
