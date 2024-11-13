FROM node:16-alpine

# Устанавливаем рабочую директорию внутри контейнера
WORKDIR /src

# Копируем только файлы из локальной директории src в /src в контейнер
COPY src/package.json src/package-lock.json ./

# Устанавливаем зависимости
RUN npm install --quiet

# Копируем все оставшиеся файлы из локальной папки src в контейнер
COPY src/ /src/

# Открываем порт для приложения
EXPOSE 3000

# Запускаем приложение
CMD ["npm", "start"]