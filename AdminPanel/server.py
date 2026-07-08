"""Small local admin panel for the Gameification Tool project.

Serves a single-page UI on http://localhost:8000 with:
  - a button to launch the exported Web build (from ../Export/)
  - a simple JSON editor for the files in ../Database/

Stdlib only, no external dependencies. Run with:
    python AdminPanel/server.py
"""

import http.server
import json
import os
import urllib.parse

PORT = 8000
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "static")
DATABASE_DIR = os.path.join(ROOT_DIR, "Database")

ALLOWED_JSON_FILES = {
    f for f in os.listdir(DATABASE_DIR) if f.endswith(".json")
}


class AdminHandler(http.server.BaseHTTPRequestHandler):
    def _send_json(self, status: int, payload) -> None:
        body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _send_file(self, path: str, content_type: str) -> None:
        try:
            with open(path, "rb") as fh:
                data = fh.read()
        except OSError:
            self.send_error(404, "Not found")
            return
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self) -> None:
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if path == "/" or path == "":
            self._send_file(os.path.join(STATIC_DIR, "index.html"), "text/html; charset=utf-8")
        elif path == "/app.js":
            self._send_file(os.path.join(STATIC_DIR, "app.js"), "application/javascript; charset=utf-8")
        elif path == "/style.css":
            self._send_file(os.path.join(STATIC_DIR, "style.css"), "text/css; charset=utf-8")
        elif path == "/api/files":
            self._send_json(200, sorted(ALLOWED_JSON_FILES))
        elif path.startswith("/api/files/"):
            name = urllib.parse.unquote(path[len("/api/files/"):])
            if name not in ALLOWED_JSON_FILES:
                self._send_json(404, {"error": "Unknown file"})
                return
            with open(os.path.join(DATABASE_DIR, name), "r", encoding="utf-8") as fh:
                content = json.load(fh)
            self._send_json(200, content)
        elif path.startswith("/game/"):
            rel = urllib.parse.unquote(path[len("/game/"):])
            full = os.path.normpath(os.path.join(ROOT_DIR, "Export", rel))
            if not full.startswith(os.path.join(ROOT_DIR, "Export")):
                self.send_error(403, "Forbidden")
                return
            content_type = "text/html; charset=utf-8"
            if full.endswith(".js"):
                content_type = "application/javascript; charset=utf-8"
            elif full.endswith(".wasm"):
                content_type = "application/wasm"
            elif full.endswith(".pck") or full.endswith(".png") or full.endswith(".ico"):
                content_type = "application/octet-stream"
            self._send_file(full, content_type)
        else:
            self.send_error(404, "Not found")

    def do_POST(self) -> None:
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path

        if not path.startswith("/api/files/"):
            self.send_error(404, "Not found")
            return

        name = urllib.parse.unquote(path[len("/api/files/"):])
        if name not in ALLOWED_JSON_FILES:
            self._send_json(404, {"error": "Unknown file"})
            return

        length = int(self.headers.get("Content-Length", 0))
        raw = self.rfile.read(length)
        try:
            parsed_body = json.loads(raw)
        except json.JSONDecodeError as e:
            self._send_json(400, {"error": f"Invalid JSON: {e}"})
            return

        with open(os.path.join(DATABASE_DIR, name), "w", encoding="utf-8") as fh:
            json.dump(parsed_body, fh, ensure_ascii=False, indent=2)

        self._send_json(200, {"ok": True})


def main() -> None:
    with http.server.ThreadingHTTPServer(("", PORT), AdminHandler) as httpd:
        print(f"Admin panel running at http://localhost:{PORT}")
        httpd.serve_forever()


if __name__ == "__main__":
    main()
