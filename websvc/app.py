from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def hello():
#    try:
#        visits = redis.incr("counter")
#    except RedisError:
#        visits = "<i>cannot connect to Redis, counter disabled</i>"

    html = "<b>Hostname:</b> {hostname}<br/>"
    return html.format(hostname=socket.gethostname())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80)