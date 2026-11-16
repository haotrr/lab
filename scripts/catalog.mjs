// Builds web/catalog.json from web/entries/*/meta.json. Usage: node scripts/catalog.mjs
import { readdir, readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const webDir = fileURLToPath(new URL("../web", import.meta.url));
const entriesDir = join(webDir, "entries");

export async function buildCatalog() {
  const dirs = await readdir(entriesDir, { withFileTypes: true });
  const entries = [];

  for (const dir of dirs) {
    if (!dir.isDirectory() || dir.name.startsWith("_")) continue;
    const metaPath = join(entriesDir, dir.name, "meta.json");
    let meta;
    try {
      meta = JSON.parse(await readFile(metaPath, "utf8"));
    } catch (error) {
      console.warn(`跳过 ${dir.name}：无法读取 meta.json（${error.message}）`);
      continue;
    }
    entries.push({
      slug: dir.name,
      title: meta.title ?? dir.name,
      summary: meta.summary ?? "",
      tags: meta.tags ?? [],
      created: meta.created ?? "",
    });
  }

  entries.sort((a, b) => b.created.localeCompare(a.created) || a.slug.localeCompare(b.slug));
  await writeFile(join(webDir, "catalog.json"), `${JSON.stringify(entries, null, 2)}\n`);
  return entries;
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const entries = await buildCatalog();
  console.log(`catalog.json 已更新：${entries.length} 个条目`);
}
