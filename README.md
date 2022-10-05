# Setup for development
Assume working directory is `~/webbhuset`
1. Clone `wh-docker` repo and switch to `localdev` branch
2. Run `./resynch.sh`. Which wil create `/lib` and `/webbhuset.fi` ourside `wh-docker` with repos.
    - Change below in `/webbhuset.fi/config/nginx.conf` (untill we fix)
         ```sh
         upstream fastcgi_backend {
            server 127.0.0.1:9000;
        }
       ```
       to 
       ```sh
         upstream fastcgi_backend {
            server wh-php:9000;
        }
       ```
   - Also make database changes in `/lib/DS/app/config.php` (Check tips below.)

3. Add `/demo.webbhuset.fi` (and other if required) to host file.
4. Run the echo command to start the container stack.
5. Goto `https://demo.webbhuset.fi`.

###### Tips:
- ##### importnant: Wait for the initial databases import to finish.
- Change `/lib/DS/app/config.php` to use docker container names for database.
- Use  `root` for database user in `/lib/DS/app/config.php`
- Use `root` as username and password for `ds` from `/lib/DS/app/config.php` for phpmyadmin.
- Add the `./resynch.sh` output paths to `.env` file inside `wh-docker` for easiness

#### Final folder structure

```sh
.
├── lib
│   ├── DS
│   ├── DS-custom
│   ├── DS-uni
│   ├── Katalogen
│   ├── Kontoret
│   ├── registry-backend
│   └── registry-client
├── webbhuset.fi
│   ├── conf
│   └── sites
└── wh-docker
    ├── README.md
    ├── docker-compose.yml
    ├── mysql
    ├── nginx
    ├── php
    ├── phpmyadmin
    ├── resynch.sh
    ├── singlesite.sh
    └── symlinks.sh
```
Happy coding.
