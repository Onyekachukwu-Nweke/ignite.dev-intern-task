const express = require('express')
const app = express()
const port = 3000

app.get('/', (req, res) => {
  res.send('Hello World! from Onyekachukwu Nweke')
})

app.listen(port, () => {
  console.log(`Hello-World app listening on port ${port}`)
})