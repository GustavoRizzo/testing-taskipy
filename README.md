# Run Project Locally
This project use python 3.12
install poetry
```bash
pip install poetry
```
install dependencies
```bash
poetry install
```
run the project, if is your first time running the project, you need to run the migrations
```bash	
poetry run task setup
```
then, or if you already run the migrations, you can run the server
```bash
poetry run task server
```
## Discover all the commands
```bash
poetry run task --list
```

# Run Project With Docker
You still need to have poetry installed, if you don't have it, you can follow the steps in the previous section
```bash
pip install poetry
poetry install
```
## Run Development Mode
```bash
poetry run task build-dev
poetry run task up-dev
```
## Run Production Mode
```bash
poetry run task build
poetry run task up
```
