# Estágio 1: Build da aplicação Vue
FROM node:18-alpine AS build-stage

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos de dependência
COPY package*.json ./

# Instala as dependências
RUN npm install

# Copia todo o restante do código-fonte para o container
COPY . .

# Roda o comando de build (gera a pasta dist/)
RUN npm run build

# Estágio 2: Configuração do servidor web (Nginx) para servir a aplicação
FROM nginx:alpine AS production-stage

# Copia a configuração personalizada do Nginx (suporte a rotas SPA)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copia os arquivos da aplicação construída do estágio anterior para o Nginx
COPY --from=build-stage /app/dist /usr/share/nginx/html

# Expõe a porta 80
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]
