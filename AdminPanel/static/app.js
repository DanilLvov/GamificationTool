const fileListEl = document.getElementById("file-list");
const editorEl = document.getElementById("editor");
const launchBtn = document.getElementById("launch-btn");

let currentFile = null;
let currentData = null;

launchBtn.addEventListener("click", () => {
	window.open("/game/Gameification_Tool.html", "_blank");
});

async function loadFileList() {
	const res = await fetch("/api/files");
	const files = await res.json();
	fileListEl.innerHTML = "";
	for (const name of files) {
		const li = document.createElement("li");
		li.textContent = name;
		li.addEventListener("click", () => openFile(name));
		fileListEl.appendChild(li);
	}
}

async function openFile(name) {
	const res = await fetch(`/api/files/${encodeURIComponent(name)}`);
	if (!res.ok) {
		alert(`Could not load ${name}`);
		return;
	}
	currentFile = name;
	currentData = await res.json();

	for (const li of fileListEl.children) {
		li.classList.toggle("active", li.textContent === name);
	}

	renderEditor();
}

function renderEditor() {
	editorEl.innerHTML = "";

	const toolbar = document.createElement("div");
	toolbar.className = "editor-toolbar";
	const title = document.createElement("h2");
	title.textContent = currentFile;
	toolbar.appendChild(title);
	editorEl.appendChild(toolbar);

	editorEl.appendChild(renderNode(currentData, []));

	const saveBar = document.createElement("div");
	saveBar.className = "save-bar";
	const saveBtn = document.createElement("button");
	saveBtn.textContent = "Save";
	saveBtn.addEventListener("click", saveCurrentFile);
	const status = document.createElement("span");
	status.id = "status";
	saveBar.appendChild(saveBtn);
	saveBar.appendChild(status);
	editorEl.appendChild(saveBar);
}

function renderNode(value, path) {
	if (value !== null && typeof value === "object") {
		const container = document.createElement("div");
		container.className = "json-node";
		const entries = Array.isArray(value)
			? value.map((v, i) => [i, v])
			: Object.entries(value);

		for (const [key, val] of entries) {
			const childPath = [...path, key];
			if (val !== null && typeof val === "object") {
				const row = document.createElement("div");
				row.className = "json-row";
				const keyEl = document.createElement("span");
				keyEl.className = "json-key";
				keyEl.textContent = `${key}:`;
				row.appendChild(keyEl);
				container.appendChild(row);
				container.appendChild(renderNode(val, childPath));
			} else {
				container.appendChild(renderLeafRow(key, val, childPath));
			}
		}
		return container;
	}

	return renderLeafRow(null, value, path);
}

function renderLeafRow(key, value, path) {
	const row = document.createElement("div");
	row.className = "json-row";

	if (key !== null) {
		const keyEl = document.createElement("span");
		keyEl.className = "json-key";
		keyEl.textContent = `${key}:`;
		row.appendChild(keyEl);
	}

	const valueEl = document.createElement("span");
	valueEl.className = "json-value";
	valueEl.textContent = JSON.stringify(value);
	row.appendChild(valueEl);

	const editBtn = document.createElement("button");
	editBtn.textContent = "Edit";
	editBtn.addEventListener("click", () => editValue(path, value));
	row.appendChild(editBtn);

	return row;
}

function editValue(path, currentValue) {
	const input = window.prompt(
		`Edit value at ${path.join(".")}\n(enter as JSON, e.g. "text", 42, true, null)`,
		JSON.stringify(currentValue)
	);
	if (input === null) return;

	let parsed;
	try {
		parsed = JSON.parse(input);
	} catch (e) {
		alert(`Invalid JSON value: ${e.message}`);
		return;
	}

	setAtPath(currentData, path, parsed);
	renderEditor();
}

function setAtPath(root, path, value) {
	let node = root;
	for (let i = 0; i < path.length - 1; i++) {
		node = node[path[i]];
	}
	node[path[path.length - 1]] = value;
}

async function saveCurrentFile() {
	const status = document.getElementById("status");
	status.textContent = "Saving…";
	const res = await fetch(`/api/files/${encodeURIComponent(currentFile)}`, {
		method: "POST",
		headers: { "Content-Type": "application/json" },
		body: JSON.stringify(currentData),
	});
	if (res.ok) {
		status.textContent = "Saved.";
	} else {
		const err = await res.json();
		status.textContent = `Error: ${err.error}`;
	}
}

loadFileList();
