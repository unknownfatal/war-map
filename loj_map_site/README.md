# Lands of Jail – Server 133 Live Map

A self‑hosted, password‑protected, real‑time map for your private **Lands of Jail** shard.

## 1.  Quick start locally

```bash
git clone <this repo>
cd loj-map
cp .env.example .env   # fill in LOJ_BASE + LOJ_JWT values
npm install
./fetch.sh            # grabs first snapshot
npm start             # visit http://localhost:3000  (browser will ask for basic‑auth)
```

## 2.  Keeping it live

Add `fetch.sh` to cron so the snapshot refreshes every 30 s:

```cron
* * * * * /home/USER/loj-map/fetch.sh
```

> **Tip:** your LoJ JWT expires ~24 h.  Recapture via mitmproxy daily or automate a `/auth/refresh` call.

## 3.  Free deployment on Render.com

Render’s _free web service_ + _free cron job_ tiers handle everything.

1. **Fork** this repo to GitHub (private is ok, still free).  
2. Sign in at <https://render.com> → **New +** → **Web Service**  
   * **Build command:** `npm install`  
   * **Start command:** `npm start`  
3. Add **Environment Vars** (`LOJ_BASE`, `LOJ_JWT`, `SERVER_ID`, `USERNAME`, `PASSWORD`).  
4. Create **Cron Job**:  
   * Command: `./fetch.sh`  
   * Schedule: `*/1 * * * *` (every minute)  
5. Hit the generated URL → enter your basic‑auth creds → live map!

_Render’s free tier idles after 15 min of no traffic; first request wakes it in ~5 s._

## 4.  Netlify (static only) + local backend

If you prefer Netlify for the front‑end, deploy `/web` as a static site and reverse‑proxy API calls to a tiny VPS running `server.js`.

---

### Security notes
* **Basic Auth** is baked in; change `USERNAME` + `PASSWORD` in your `.env`.  
* All data stays within your account; no third‑party analytics.  

---

Enjoy ruling your island!  PRs welcome.
