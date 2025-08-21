import net from "net";
import fs from "fs";
import path from "path";

// Crie uma conexão com o servidor
// Usar 192.168.1.2 para rodar com o roteador
const bombClient = net.createConnection(
  { port: 22001, host: process.env.BACKEND_HOST },
  () => {
    console.log("Bomba conectada ao servidor");

    // Envie dados para o servidor
    let fileNum = 1;

    let readFilesInterval: NodeJS.Timer = setInterval(() => {
      // if (fileNum > 500) return clearInterval(this);
      // `file${(fileNum % 160) + 1}.txt`

      fs.readFile(
        path.resolve(
          __dirname,
          "..",
          "samtronic-files",
          `file${(fileNum % 7) + 1}.txt`
        ),
        "ascii",
        (err, data) => {
          if (err) {
            console.error(err);
            return;
          }

          // TODO - Enviar para o backend
          bombClient.write(Buffer.from(data));
        }
      );

      fileNum++;
    }, 1000);

    // Feche a conexão após o envio
    // bombClient.end();
  }
);

// Quando o cliente recebe dados do servidor
bombClient.on("data", (data) => {
  console.log(data);
});

// Quando a conexão com o servidor é encerrada
bombClient.on("end", () => {
  console.log("Bomba desconectada do servidor");
});
