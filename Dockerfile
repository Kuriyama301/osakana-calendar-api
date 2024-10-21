# ビルドステージ
FROM ruby:3.3.4 AS builder

ARG WORKDIR=/app
ENV WORKDIR=$WORKDIR

WORKDIR $WORKDIR

# 依存関係のインストールを先に行い、キャッシュを活用
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local without 'development test' \
    && bundle install --jobs 4 --retry 3 \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

# その後、アプリケーションコードをコピー
COPY . .

# 実行ステージ
FROM ruby:3.3.4-slim

ARG WORKDIR=/app
ENV WORKDIR=$WORKDIR \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

RUN apt-get update -qq && apt-get install -y postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $WORKDIR

COPY --from=builder $WORKDIR $WORKDIR
COPY --from=builder /usr/local/bundle /usr/local/bundle

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]