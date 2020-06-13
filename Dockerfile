FROM nginx:stable-alpine

COPY --from=docker.pkg.github.com/cardsity/vue-client/cardsity-vue-client:latest /app/dist/ /var/www/client/

CMD ["nginx", "-g", "daemon off;"]
