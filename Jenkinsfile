pipeline {
    agent any

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/Ahad9049/django-notes-app.git'
            }
        }

        stage('Create Virtual Environment and install dependencies') {
            steps {
                sh '''
                    python3 -m venv django
                    .django/bin/activate
                    ./django/bin/pip install --upgrade pip
                    ./django/bin/pip install -r requirements.txt
                '''
            }
        }
        stage('Run App Locally') {
            steps {
                sh '''
                    ./django/bin/python manage.py makemigrations
                    ./django/bin/python manage.py migrate
                    ./django/bin/python manage.py runserver 0.0.0.0:8000
                '''
            }
        }
    }
