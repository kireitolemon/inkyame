init:
	docker compose build
	docker compose up -d
	docker compose run vue-app npm install face-api.js p5 vite-plugin-pwa axios vue-axios
	docker compose down

	clear
	@echo "Finish init. \nTo start development, run the following command:\n$ make start"
start:
	docker compose up
stop:
	docker compose down
reset:
	docker compose up --build