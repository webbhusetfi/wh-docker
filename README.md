# Running locally

# Create the following folder structure

```sh
├── lib
├── webbhuset.fi
└── wh-docker
```

- Inside `wh-docker` is the Docker repository

- Inside `lib` is the DS and other repositry

- Inside `webbhuset.fi` is Configs and Sites from production server

so after cloning all repos and copying `webbhuset.fi` using `resynch.sh` the folder structure will be something like:

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

- Then `cd wh-docker` 
- Run `docker-compose up --build`

# Prerequisites 
- A mysqldump from database
- Adding sites from 

    ```
    webbhuset.fi
    ├── conf
    └── sites
        ├── auf.webbhuset.fi
        └── sa.webbhuset.fi
    ```
    to the local machine hosts.
- checking `/webbhuset/sites` incluse `.nginx.map`

- check that `webbhuset/conf/nginx/server` directory is empty to by pass SSL locally

- define local database connection in DS
    - currently from `/lib/DS/.env`


open the websites like `auf.webbhuset.fi`