from flask import Flask, render_template, send_from_directory
import os
import subprocess

app = Flask(__name__)
LATEX_FILE = "yourfile.tex"
OUTPUT_DIR = "static"
PDF_FILE = "yourfile.pdf"


def compile_latex():
    """Compile LaTeX to PDF."""
    if os.path.exists(os.path.join(OUTPUT_DIR, PDF_FILE)):
        os.remove(os.path.join(OUTPUT_DIR, PDF_FILE))  # Remove old PDF
    
    subprocess.run(
        ["pdflatex", "-interaction=nonstopmode", "-output-directory", OUTPUT_DIR, LATEX_FILE],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )


@app.route("/")
def index():
    """Render the HTML viewer."""
    return render_template("index.html", pdf_file=PDF_FILE)


@app.route("/pdf")
def serve_pdf():
    """Serve the compiled PDF."""
    return send_from_directory(OUTPUT_DIR, PDF_FILE, mimetype="application/pdf")


if __name__ == "__main__":
    compile_latex()  # Compile LaTeX on startup
    app.run(debug=True, port=5000)
