from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "<h1> Working from Docker, using automated build image</h1>"


if __name__=="__main__":
    app.run()

