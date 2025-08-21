import net from "net";
import fs from "fs";
import path from "path";

// Crie uma conexão com o servidor
// Usar 192.168.1.2 para rodar com o roteador
const ventilatorClient = net.createConnection(
  { port: 23000, host: process.env.BACKEND_HOST },
  () => {
    console.log("Ventilador conectado ao servidor");

    // Envie dados para o servidor
    let fileNum = 1;

    let readFilesInterval: NodeJS.Timer = setInterval(() => {
      // if (fileNum > 500) return clearInterval(this);

      fs.readFile(
        path.resolve(
          __dirname,
          "..",
          "tecme-files",
          `file${(fileNum % 1000) + 1}.bin`
        ),
        "ascii",
        (err, data) => {
          if (err) {
            console.error(err);
            return;
          }

          // TODO - Enviar para o backend
          ventilatorClient.write(data);
        }
      );

      fileNum++;
    }, 700);

    // Feche a conexão após o envio
    // ventilatorClient.end();
  }
);

// Quando o cliente recebe dados do servidor
ventilatorClient.on("data", (data: string) => {
  console.log(`Servidor diz: ${data}`);
});

// Quando a conexão com o servidor é encerrada
ventilatorClient.on("end", () => {
  console.log("Ventilador desconectado do servidor");
});
