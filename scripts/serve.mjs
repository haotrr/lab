// Zero-dependency static server for web/. Usage: node scripts/serve.mjs [--port 5173]
import { createServer } from "node:http";
import { createReadStream } from "node:fs";
import { stat } from "node:fs/promises";
import { extname, join, normalize, resolve, sep } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(fileURLToPath(new URL("../web", import.meta.url)));
const portArg = process.argv.indexOf("--port");
const port = Number(portArg > -1 ? process.argv[portArg + 1] : process.env.PORT ?? 5173);

const types = {
  ".html": "text/html; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".js": "text/javascript; charset=utf-8",
  ".mjs": "text/javascript; charset=utf-8",
  ".json": "application/json; charset=utf-8",
  ".md": "text/markdown; charset=utf-8",
  ".svg": "image/svg+xml",
  ".png": "image/png",
  ".jpg": "image/jpeg",
  ".jpeg": "image/jpeg",
  ".gif": "image/gif",
  ".webp": "image/webp",
  ".avif": "image/avif",
  ".woff2": "font/woff2",
  ".mp4": "video/mp4",
  ".webm": "video/webm",
};

createServer(async (req, res) => {
  const pathname = decodeURIComponent(new URL(req.url, "http://localhost").pathname);
  let file = normalize(join(root, pathname));
  if (file !== root && !file.startsWith(root + sep)) {
    res.writeHead(403).end("Forbidden");
    return;
  }

  try {
    let info = await stat(file);
    if (info.isDirectory()) {
      if (!pathname.endsWith("/")) {
        res.writeHead(301, { Location: `${pathname}/` }).end();
        return;
      }
      file = join(file, "index.html");
      info = await stat(file);
    }
    res.writeHead(200, {
      "Content-Type": types[extname(file).toLowerCase()] ?? "application/octet-stream",
      "Content-Length": info.size,
      "Cache-Control": "no-store",
    });
    createReadStream(file).pipe(res);
  } catch {
    res.writeHead(404, { "Content-Type": "text/plain; charset=utf-8" }).end("Not found");
  }
}).listen(port, () => {
  console.log(`Lab → http://localhost:${port}`);
});
