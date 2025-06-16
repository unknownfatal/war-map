import express from 'express';
import fs from 'fs/promises';
import path from 'path';

const PORT = process.env.PORT || 3000;
const USER = process.env.USERNAME || 'warden';
const PASS = process.env.PASSWORD || 'changeme';

const app = express();

// Basic‑Auth middleware
app.use((req,res,next)=>{
  const auth = req.headers.authorization || '';
  const token = auth.split(' ')[1] || '';
  const [u,p] = Buffer.from(token,'base64').toString().split(':');
  if(u===USER && p===PASS){
    return next();
  }
  res.set('WWW-Authenticate','Basic realm="LoJMap"');
  res.status(401).send('Authentication required');
});

// static files
app.use(express.static('web'));

app.get('/api/players', async (_req,res)=>{
  try{
    const data = await fs.readFile('web/snapshot.json','utf8');
    res.type('application/json').send(data);
  }catch(err){
    res.status(500).json({error:'snapshot not ready'});
  }
});

app.listen(PORT, ()=>console.log(`LoJ map running on :${PORT}`));
