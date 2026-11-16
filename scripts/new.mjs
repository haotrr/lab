// Creates a web entry from the template. Usage: node scripts/new.mjs <slug> ["Title"] ["Summary"]
import { cp, readFile, writeFile, access } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";
import { buildCatalog } from "./catalog.mjs";

const [slug, title = slug, summary = "待补充描述"] = process.argv.slice(2);

if (!slug || !/^[a-z0-9]+(-[a-z0-9]+)*$/.test(slug)) {
  console.error('用法：npm run new -- <kebab-case-slug> ["Title"] ["Summary"]');
  process.exit(1);
}

const entriesDir = fileURLToPath(new URL("../web/entries", import.meta.url));
const target = join(entriesDir, slug);

try {
  await access(target);
  console.error(`已存在：web/entries/${slug}`);
  process.exit(1);
} catch {}

await cp(join(entriesDir, "_template"), target, { recursive: true });

const created = new Date().toLocaleDateString("sv-SE");
const values = { title, summary, created };
const jsonValues = Object.fromEntries(Object.entries(values).map(([k, v]) => [k, JSON.stringify(v).slice(1, -1)]));

for (const file of ["index.html", "meta.json", "notes.md"]) {
  const path = join(target, file);
  const vars = file.endsWith(".json") ? jsonValues : values;
  const content = (await readFile(path, "utf8")).replace(/\{\{(\w+)\}\}/g, (m, key) => vars[key] ?? m);
  await writeFile(path, content);
}

await buildCatalog();
console.log(`已创建 web/entries/${slug}/`);
