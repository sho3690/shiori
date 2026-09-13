#!/bin/sh
# app.html（Artifact用の本文）から、単体で開ける index.html を組み立てる
cd "$(dirname "$0")"
{
  printf '%s\n' '<!doctype html>' '<html lang="ja">' '<head>' '<meta charset="utf-8">' \
    '<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">' \
    '<meta name="theme-color" content="#F4EFE4">' \
    '<meta name="apple-mobile-web-app-capable" content="yes">' \
    '<meta name="mobile-web-app-capable" content="yes">' \
    '<link rel="icon" href="icons/icon-192.png" type="image/png">' \
    '<link rel="apple-touch-icon" href="icons/icon-180.png">' \
    '<link rel="manifest" href="manifest.webmanifest">' \
    '<meta name="apple-mobile-web-app-status-bar-style" content="default">' \
    '<meta name="apple-mobile-web-app-title" content="栞">' \
    '<meta name="description" content="偉人や名著の書き手の一言を、毎日ひとつ。">'
  cat app.html
  printf '%s\n' '</head>' '<body></body>' '</html>'
} > index.tmp
# <head> に入れられるのは title/link/style だけなので、本文部分は body へ移す
node -e '
const fs=require("fs");let s=fs.readFileSync("index.tmp","utf8");
const i=s.indexOf("</style>")+8;const head=s.slice(0,i);let rest=s.slice(i);
rest=rest.replace("</head>\n<body></body>\n</html>\n","");
const sw="<script>if(\"serviceWorker\" in navigator&&location.protocol.startsWith(\"http\")){addEventListener(\"load\",()=>navigator.serviceWorker.register(\"./sw.js\").catch(()=>{}))}</script>\n";fs.writeFileSync("index.html",head+"\n</head>\n<body>"+rest+sw+"</body>\n</html>\n");fs.unlinkSync("index.tmp");'
