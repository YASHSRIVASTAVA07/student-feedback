from flask import Flask, render_template, request

app = Flask(__name__)

feedback_list = []

@app.route('/')
def index():
    return render_template('index.html', feedbacks=feedback_list)

@app.route('/submit', methods=['POST'])
def submit():
    name = request.form.get('name')
    feedback = request.form.get('feedback')

    if name and feedback:
        feedback_list.append({'name': name, 'feedback': feedback})

    return render_template('index.html', feedbacks=feedback_list, message="Feedback submitted successfully!")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
