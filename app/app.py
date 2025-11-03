from flask import Flask, render_template, request, redirect
import sqlite3

app = Flask(__name__)
DB = "feedback.db"

# Initialize DB
def init_db():
    with sqlite3.connect(DB) as conn:
        conn.execute("CREATE TABLE IF NOT EXISTS feedback (name TEXT, feedback TEXT)")

@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form["name"]
        feedback = request.form["feedback"]
        with sqlite3.connect(DB) as conn:
            conn.execute("INSERT INTO feedback (name, feedback) VALUES (?, ?)", (name, feedback))
        return redirect("/")
    with sqlite3.connect(DB) as conn:
        rows = conn.execute("SELECT name, feedback FROM feedback").fetchall()
    return render_template("index.html", rows=rows)

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=5000)
