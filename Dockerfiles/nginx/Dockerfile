FROM nginx:stable-alpine

COPY --from=docker.pkg.github.com/cardsity/vue-client/cardsity-vue-client:latest /app/dist/ /var/www/client/
RUN mkdir /app/
COPY entrypoint.sh /app/entrypoint.sh
COPY nginx.conf /app/nginx.conf.template

CMD ["/app/entrypoint.sh"]
