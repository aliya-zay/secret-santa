const express = require('express');
const app = express();
const fs = require('node:fs');
const path = require('node:path');
const bodyParser = require('body-parser');

app.use(bodyParser.json());

const participantsFilePath = path.join(__dirname, 'participants.json'); // Путь к JSON-файлу

// Получение списка участников
app.get('/participants', (req, res) => {
  fs.readFile(participantsFilePath, 'utf8', (err, data) => {
    if (err) {
      res.status(500).send('Error reading participants file');
    } else {
      try {
        const participants = JSON.parse(data);
        res.json(participants);
      } catch (error) {
        res.status(500).send('Error parsing participants file');
      }
    }
  });
});

// Добавление участника
app.post('/participants', (req, res) => {
  const newParticipant = req.body;
  fs.readFile(participantsFilePath, 'utf8', (err, data) => {
    if (err) {
      if(err.code === 'ENOENT'){
        fs.writeFile(participantsFilePath, '[]', (err) => {
          if(err) res.status(500).send('Error creating participants file');
          else res.status(201).send("File Created");
        })
      } else {
        res.status(500).send('Error reading participants file');
      }
    } else {
      try {
        let participants = JSON.parse(data);
        participants.push(newParticipant);
        fs.writeFile(participantsFilePath, JSON.stringify(participants, null, 2), err => {
          if (err) res.status(500).send('Error writing participants file');
          else res.status(201).send('Participant added');
        });
      } catch (error) {
        res.status(500).send('Error parsing participants file');
      }
    }
  });
});

const port = 3000;
app.listen(port, () => console.log(`Server listening on port ${port}`));