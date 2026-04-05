#<---------stage-1 ------>

FROM python:3.10-slim AS builder

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends gcc libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

#----------stage-2--------->

FROM python:3.10-slim

RUN adduser --disabled-password --gecos '' appuser

WORKDIR /app

ENV PYTHONUNBUFFERED=1 	PYTHONPATH="/install" PATH="/install/bin:$PATH"

COPY --from=builder /install /usr/local

COPY . .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8000

CMD ["gunicorn","notesapp.wsgi:application","--bind","0.0.0.0:8000"]

