from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Working from Docker build image"


if __name__=="__main__":
    app.run()

