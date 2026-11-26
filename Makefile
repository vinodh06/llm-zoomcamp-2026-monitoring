run:
	uv run python assistant.py

chat:
	uv run streamlit run app.py

network:
	docker network inspect monitoring >/dev/null 2>&1 || docker network create monitoring

postgres: network
	@if [ "$$(docker ps -aq -f name=^course-assistant-pg$$)" ]; then \
		docker start course-assistant-pg; \
	else \
		docker run -d \
			--name course-assistant-pg \
			--network monitoring \
			-e POSTGRES_USER=user \
			-e POSTGRES_PASSWORD=password \
			-e POSTGRES_DB=course_assistant \
			-p 5432:5432 \
			-v pgdata:/var/lib/postgresql/data \
			postgres:17; \
	fi

query:
	uv run python db_query.py