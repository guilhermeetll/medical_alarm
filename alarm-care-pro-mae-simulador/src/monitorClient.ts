import net from "net";
import fs from "fs";
import path from "path";

// Crie uma conexão com o servidor
// Usar 192.168.1.2 para rodar com o roteador
const monitorClient = net.createConnection(
  { port: 2222, host: process.env.BACKEND_HOST },
  () => {
    console.log("Monitor conectado ao servidor");

    // Envie dados para o servidor
    let fileNum = 1;

    let readFilesInterval: NodeJS.Timer = setInterval(() => {
      // if (fileNum > 500) return clearInterval(this);

      fs.readFile(
        path.resolve(
          __dirname,
          "..",
          "prolife-files",
          `file(${(fileNum % 489) + 1}).hl7`
        ),
        "ascii",
        (err, data) => {
          if (err) {
            console.error(err);
            return;
          }

          // TODO - Enviar para o backend
          monitorClient.write(data);
        }
      );

      fileNum++;
    }, 200);

    // Feche a conexão após o envio
    // monitorClient.end();
  }
);

// Quando o cliente recebe dados do servidor
monitorClient.on("data", (data: string) => {
  console.log(`Servidor diz: ${data}`);
});

// Quando a conexão com o servidor é encerrada
monitorClient.on("end", () => {
  console.log("Monitor desconectado do servidor");
});
